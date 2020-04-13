//
//  OnTheMapResponse.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/12/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation

struct Account: Codable {
    let statusCode: Int?
    let account: AccountDetails?
    let session: SessionDetails?
}

struct AccountDetails: Codable {
    let registered: Bool?
    let key: String?
}

struct SessionDetails: Codable {
    let id: String?
    let expiration: String?
}
