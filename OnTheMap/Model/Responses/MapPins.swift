//
//  MapPins.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/13/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation

struct MapPins: Codable {
    let results: [Student]
}

struct Student: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String?
    let createdAt: String?
    let updatedAt: String?
}

