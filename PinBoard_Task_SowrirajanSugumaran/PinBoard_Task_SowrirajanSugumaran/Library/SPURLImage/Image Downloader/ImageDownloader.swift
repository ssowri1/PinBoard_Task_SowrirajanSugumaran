//
//  ImageDownloader.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import Foundation
import UIKit
/// The class is used to download the url images
public class ImageDownloader {
    /// Check certificates type
    private var trustsAllCertificates = false

    /// timeout
    public var timeoutInterval = 30.0
    /// cancelstate intervel
    public var cacheStaleInterval = 30.0
    /// Headers
    private var globalRequestHeaders = SPGlobalHeaders()
    /// Credentials
    private var globalCredentials = SPGlobalCredentials()
    /// Operation Queue
    private let operationQueue = OperationQueue()
    /// To download image from url
    public func downloadImage(fromUrl url: URL, cachePolicy: NSURLRequest.CachePolicy, requestModification: ((_ request: URLRequest) -> URLRequest)? = nil, customIdentifier: String? = nil, completion: ((_ result: SPDownloadCompletionType, _ invalidated: Bool) -> ())?) -> String {
        let identifier: String = customIdentifier ?? UUID().uuidString
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        // set headers
        request.addValue("image/*, */*; q=0.5", forHTTPHeaderField: "Accept")
        for (key, value) in globalRequestHeaders.headersForHost(url.host) {
            request.addValue(value, forHTTPHeaderField: key)
        }
        if let closure = requestModification {
            request = closure(request)
        }
        let operation = SPOperation(urlRequest: request, identifier: identifier, callbackQueue: DispatchQueue.main, downloadFinishedBlock: { operation, result in
            switch result {
            case .canceled:
                completion?(.canceled, operation.invalidated)
            case .error(let error):
                completion?(.error(error: error as NSError), operation.invalidated)
            case .success(let image, let data):
                completion?(.success(image: image, data: data), operation.invalidated)
            }
        })
        // configure operation
        if let credentials = globalCredentials.credentialsForHost(url.host) {
            operation.credentials  = credentials
        }
        operation.trustsAllCertificates = trustsAllCertificates
        operationQueue.addOperation(operation)
        return identifier
    }
}
