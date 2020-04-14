//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/12/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation


class OnTheMapClient {
    
    struct Auth {
        static var sessionID = ""
        static var uniqueKey = ""
        static var students = [] as [Student]
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case pinsEndpoint
        case postman
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .pinsEndpoint: return Endpoints.base + "StudentLocation"
            case .postman: return "https://postman-echo.com/post"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ResponseType.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            // discount 5 bytes
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            // print(String(data: newData, encoding: .utf8)!)
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ResponseType.self, from: newData) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginReq = LoginRequest(username: username, password: password)
        let udacityCreds = Udacity(udacity: loginReq)
        let body = udacityCreds
        taskForPOSTRequest(url: Endpoints.login.url, responseType: Account.self, body: body) { response, error in
            if let response = response {
                if(response.statusCode != nil) {
                    // Store credentials
                    Auth.sessionID = response.session?.id as! String
                    Auth.uniqueKey = response.account?.key as! String
                    completion(true, nil)
                }
                else {
                completion(false, error)
                }
            }
        }
    }
    
    class func loadPins(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.pinsEndpoint.url, responseType: MapPins.self) { response, error in
            if let response = response {
                Auth.students = response.results
                // print(Auth.students[0].firstName)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}

    