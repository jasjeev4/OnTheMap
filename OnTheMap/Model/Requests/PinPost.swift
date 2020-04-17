//
//  PinPost.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/16/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation

struct PinPost: Codable {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let mapString: String?
    let latitude: Double?
    let longitude: Double?
}
