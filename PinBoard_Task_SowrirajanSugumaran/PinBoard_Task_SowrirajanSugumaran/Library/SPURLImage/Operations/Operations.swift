//
//  Operations.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import Foundation
import UIKit
public class SPOperation: Operation, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    /// To check the session invalidate
    public var invalidated = false
    /// To check the all certificates
    public var trustsAllCertificates = false
    /// Url credentials
    public var credentials: URLCredential? = nil
    /// identifier of tasks
    public let identifier: String
    /// call back dispatchqueue
    private let finishedCallbackQueue: DispatchQueue
    /// the request to be made
    private let urlRequest: URLRequest
    /// a completion block
    private let finishedBlock: SPOperationCompletionBlock
    /// the urlsession to use for the request
    private weak var urlSession: URLSession?
    /// identifiers
    private var completionBlockIdentifiers = Set<String>()
    /// enum for states
    enum State {
        case ready, executing, finished
        func keyPath() -> String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                return "isExecuting"
            case .finished:
                return "isFinished"
            }
        }
    }
    var state: State = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath())
            willChangeValue(forKey: state.keyPath())
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath())
            didChangeValue(forKey: state.keyPath())
        }
    }
    /// To start the process
    override public func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
            main()
        }
    }
    // MARK: - NSOperation
    override public var isReady: Bool {
        return super.isReady && state == .ready
    }
    override public var isExecuting: Bool {
        return state == .executing
    }
    override public var isFinished: Bool {
        return state == .finished
    }
    override public var isAsynchronous: Bool {
        return true
    }
    // MARK: Initialisation - URL REQUEST
    public init(urlRequest request: URLRequest, identifier id: String, callbackQueue: DispatchQueue, downloadFinishedBlock:  @escaping SPOperationCompletionBlock) {
        urlRequest = request
        identifier = id
        finishedBlock = downloadFinishedBlock
        finishedCallbackQueue = callbackQueue
        super.init()
    }
    // MARK: - Entry point
    override public func main() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        configuration.httpShouldUsePipelining = true
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        self.urlSession = urlSession
        let task = urlSession.downloadTask(with: urlRequest)
        task.resume()
    }
    // MARK: - NSURLSessionDownloadDelegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse else { return }
        
        if (200...299).contains(response.statusCode) {
            if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
                if let request = downloadTask.currentRequest {
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                }
                finishedCallbackQueue.async {
                    self.finishedBlock(self, .success(image: image, data: data))
                }
            } else {
                finishedCallbackQueue.async {
                    self.finishedBlock(self, .error(error: NSError(domain: "SPOperation", code: 0, userInfo: [NSLocalizedDescriptionKey: "unable to decode image"])))
                }
            }
        } else {
            finishedCallbackQueue.async {
                self.finishedBlock(self, .error(error: NSError(domain: "SPOperation", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "unexepected status code \(response.statusCode)"])))
            }
        }
    }
    // MARK: - NSURLSessionTaskDelegate
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // only connection errors are handled here!
        if let error = error {
            finishedCallbackQueue.async {
                self.finishedBlock(self, .error(error: error as NSError))
            }
        }
        urlSession?.invalidateAndCancel()
        state = .finished
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust, challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if trustsAllCertificates {
                completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else if let credentials = credentials {
            if let currentRequest = task.currentRequest, currentRequest.value(forHTTPHeaderField: "Authorization") == nil {
                completionHandler(.useCredential, credentials)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    // MARK: - Utility
    public override func cancel() {
        invalidated = true
        urlSession?.invalidateAndCancel()
        finishedBlock(self, .canceled)
        super.cancel()
        state = .finished
    }
    public func matches(urlRequest: URLRequest) -> Bool {
        return urlRequest.url != nil && self.urlRequest.url == urlRequest.url
    }
    func appendCompletionBlock(block: (() -> ())?) {
        guard let block = block else { return }
        if let completionBlock = completionBlock {
            self.completionBlock = {
                completionBlock()
                block()
            }
        } else {
            completionBlock = block
        }
    }
}
