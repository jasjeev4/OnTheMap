//
//  MapPins.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/13/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation

struct MapPins: Codable {
    let results: [Results]
}

struct Results: Codable {
    let firstName: String?
    let lastName: String?
    let longitude: String?
    let latitute: String?
}

