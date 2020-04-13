//
//  login.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/12/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let udacity: LoginRequest?
}

struct LoginRequest: Codable {
    
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
