//
//  ApiModel.swift
//  PinBoard_Task_SowrirajanSugumaran
//
//  Created by Sowrirajan S on 12/05/19.
//  Copyright © 2019 ssowr1. All rights reserved.
//
import UIKit
/// Userdetails model
struct UserDetails: Codable {
    let id: String
    let created_at: String
    let user: Users
}

struct Users: Codable {
    let name: String
    let profile_image: ProfileImages
}

struct ProfileImages: Codable {
    let small: String
    let medium: String
    let large: String
}
