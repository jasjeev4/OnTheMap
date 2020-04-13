////
////  LoginSession.swift
////  OnTheMap
////
////  Created by JASJEEV on 4/11/20.
////  Copyright © 2020 Lorgarithmic Science. All rights reserved.
////
//
//import Foundation
//
//class LoginSession {
//
//
//    func login(username: String, password: String) {
//        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let req = LoginRequest(username: username, password: password)
//        let udacityCreds = Udacity(udacity: req)
//
//        let encoder = JSONEncoder()
//        //change this for production
//        let data = try! encoder.encode(udacityCreds)
//
//        // encoding a JSON body from a string, can also use a Codable struct
//        request.httpBody = data
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//          if error != nil { // Handle error…
//              return
//          }
//          let range = 5..<data!.count
//          let newData = data?.subdata(in: range) /* subset response data! */
//          print(String(data: newData!, encoding: .utf8)!)
//
//          let response = try? JSONDecoder().decode(Account.self, from: newData!)
//          if(response?.statusCode == nil) {
//                // Save to store
//                 Store.init(session: response?.session?.id, uniqueKey: response?.account?.key)
//                return true
//          }
//          else {
//            return false
//          }
//
//
//        }
//        task.resume()
//    }
//
//}
//
