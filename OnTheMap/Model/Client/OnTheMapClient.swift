//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/12/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import MapKit

class OnTheMapClient {
    
    struct Auth {
        static var sessionID = ""
        static var uniqueKey = ""
        static var students = [] as [Student]
        static var nickname = "John Do"
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case pinsEndpoint
        case user
        case location
        case postman
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .user: return Endpoints.base + "users/"
            case .location: return Endpoints.base + "StudentLocation"
            case .pinsEndpoint: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, skipRange: Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
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
            var newData: Data
            if(skipRange) {
                // discount 5 bytes
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            else {
                newData = data
            }
            print(String(data: newData, encoding: .utf8)!)
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
        taskForPOSTRequest(url: Endpoints.login.url, skipRange: true, responseType: Account.self, body: body) { response, error in
            if let response = response {
                if(response.status == nil) {
                    // Store credentials
                    Auth.sessionID = response.session?.id as! String
                    Auth.uniqueKey = response.account?.key as! String
                    completion(true, nil)
                }
                else {
                completion(false, error)
                }
            }
            else {
                completion(false, error)
            }
        }
    }
    
    class func postPin(body: PinPost, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.location.url, skipRange: false, responseType: CreateObject.self, body: body) { response, error in
            if let response = response {
                if(response.status == nil) {
                    completion(true, nil)
                completion(false, error)
                }
            }
            else {
                completion(false, error)
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
    
    class func loadNickname(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.user.url, responseType: Nickname.self) { response, error in
            if let response = response {
                Auth.nickname = response.nickname!
                // print(Auth.students[0].firstName)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func uploadPinHelper(coordinates: CLLocationCoordinate2D, location: String, mediaURL: String) {
        // load user's name
        let firstName = "First"
        let lastName = "Last"
        
        let obj = PinPost(uniqueKey: Auth.uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL, mapString: location, latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    class func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
}

    
