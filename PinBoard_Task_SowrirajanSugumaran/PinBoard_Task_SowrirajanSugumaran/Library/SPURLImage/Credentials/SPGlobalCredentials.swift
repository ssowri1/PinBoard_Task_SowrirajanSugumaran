//
//  File.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by user on 14/05/19.
//  Copyright © 2019 ssowri1. All rights reserved.
//
import Foundation
//// MARK: - SPGlobalCredentials
public class SPGlobalCredentials {
    private var allHostsCredentials: URLCredential?
    private var specificHostCredentials = [String: URLCredential]()
    func setCredentials(_ credentials: URLCredential?, forHost host: String?) {
        if let host = host {
            specificHostCredentials[host] = credentials
        } else {
            allHostsCredentials = credentials
        }
    }
    func credentialsForHost(_ host: String?) -> URLCredential? {
        if let host = host {
            if let specificCredentials = specificHostCredentials[host] {
                return specificCredentials
            } else {
                return allHostsCredentials
            }
        } else {
            return allHostsCredentials
        }
    }
}
