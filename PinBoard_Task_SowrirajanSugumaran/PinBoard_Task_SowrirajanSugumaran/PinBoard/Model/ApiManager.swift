//
//  ApiManager.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by Sowrirajan S on 12/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import UIKit
class ApiManager: NSObject {
    /// Network call for getting pinboard images
    ///
    /// - Parameters
    ///  - url: String
    ///  - completion handler: calling api while completed function
    class func getPinBoardImages(url: String,
                                 completion: @escaping (_ data: [UserDetails]?, _ error: Error?) -> Void) {
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let userDetails = try decoder.decode([UserDetails].self, from: data)
                completion(userDetails, nil)
            } catch let err {
                completion(nil, err)
            }
            }.resume()
        
    }
    /// Convert JSON from url
    ///
    /// - Parameters
    ///  - url: String
    ///  - completion handler: calling api while completed function
    class func getJSONfromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            completion(responseData, nil)
        }
        task.resume()
    }
}
