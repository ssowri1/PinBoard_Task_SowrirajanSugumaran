//
//  Configuration.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import Foundation
import UIKit
// MARK: - SPGlobalHeaders
public class SPGlobalHeaders {
    private var allHostsHeaders = [String: String]()
    private var specificHostHeaders = [String: [String: String]]()
    func setHeader(_ name: String, value: String?, forHost host: String?) {
        if let host = host {
            var headers = specificHostHeaders[host] ?? [String: String]()
            headers[name] = value
            specificHostHeaders[host] = headers
        } else {
            allHostsHeaders[name] = value
        }
    }
    func setHeaders(_ headers: [String: String], forHost host: String?) {
        if let host = host {
            specificHostHeaders[host] = headers
        } else {
            allHostsHeaders = headers
        }
    }
    func headersForHost(_ host: String?) -> [String: String] {
        if let host = host {
            if let specificHeaders = specificHostHeaders[host] {
                return specificHeaders.reduce(allHostsHeaders) { (dict, e) in
                    var mutableDict = dict
                    mutableDict[e.0] = e.1
                    return mutableDict
                }
            } else {
                return allHostsHeaders
            }
        } else {
            return allHostsHeaders
        }
    }
}
/// enum download report status
public enum SPDownloadCompletionType {
    case canceled
    case error(error: NSError)
    case success(image: UIImage, data: Data)
}
/// Completion block typealias
public typealias SPOperationCompletionBlock = (_ operation: SPOperation, _ result: SPDownloadCompletionType) -> ()
