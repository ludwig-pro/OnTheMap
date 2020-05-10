//
//  APIClient.swift
//  OnTheMap
//
//  Created by ludwig vantours on 29/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

class APIClient {
  
  struct Auth {
    fileprivate static var accountId = 0
    fileprivate static var requestToken = ""
    fileprivate static var sessionId = ""
  }
  
  enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    case requestSession
    case deleteSession
    case getUserData(String)
    case getStudentsLocation
    case postStudentLocation
    case updateStudentLocation(String)
    
    var stringValue: String {
      switch self {
        case .getUserData(let userId): return Endpoints.base + "/users/\(userId)"
        case .requestSession, .deleteSession: return Endpoints.base + "/session"
        case .getStudentsLocation: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
        case .postStudentLocation: return Endpoints.base + "/StudentLocation"
        case .updateStudentLocation(let objectId): return Endpoints.base + "/StudentLocation" + objectId
      }
    }
      
      var url: URL {
        return URL(string: stringValue)!
      }
    }
  
  
  @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isSecureResponse: Bool, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let newData = isSecureResponse ? data.subdata(in: (5..<data.count)) : data
      let decoder = JSONDecoder()
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: newData)
        DispatchQueue.main.async {
          completion(responseObject, nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
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
  
  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isSecureResponse: Bool, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
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
      let range = (5..<data.count)
      let newData = isSecureResponse ? data.subdata(in: range) : data
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: newData)
        DispatchQueue.main.async {
          completion(responseObject, nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
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
  
  
  class func getStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getStudentsLocation.url , responseType: StudentLocationResponse.self, isSecureResponse: false) { (response, error) in
      if let response = response {
        Students.locations = response.results
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func postStudentLocation( mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void ) {
    let body = StudentLocationRequest(uniqueKey: User.userData.key, firstName: User.userData.firstName, lastName: User.userData.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
    
    taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentLocationResponse.self, isSecureResponse: false, body: body) { response, error in
      if let response = response  {
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func updateStudentLocation( mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void ) {
    let body = StudentLocationRequest(uniqueKey: User.userData.key, firstName: User.userData.firstName, lastName: User.userData.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
    var request = URLRequest(url: Endpoints.updateStudentLocation(User.session.id ?? "").url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONEncoder().encode(body)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(false, error)
        }
        return
      }
      let decoder = JSONDecoder()
      do {
        _ = try decoder.decode(PutStudentLocationResponse.self, from: data)
        DispatchQueue.main.async {
          completion(true, nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
          DispatchQueue.main.async {
            completion(false, errorResponse)
          }
          
        } catch {
          DispatchQueue.main.async {
            completion(false, error)
          }
        }
      }
    }
    task.resume()
  }
  
  class func requestUserSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    let body = SessionRequest(udacity: Udacity(username: username, password: password))
    taskForPOSTRequest(url: Endpoints.requestSession.url, responseType: SessionResponse.self, isSecureResponse: true,body: body) { response, error in
      if let response = response {
        User.account.key = response.account.key
        User.account.registered = response.account.registered
        User.session.id = response.session.id
        User.session.expiration = response.session.expiration
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  class func deleteUserSession(completion: @escaping (Bool, Error?) -> Void) {
    var request = URLRequest(url: Endpoints.deleteSession.url)
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
        DispatchQueue.main.async {
          completion(false, error)
        }
        return
      }
      let range = (5..<data!.count)
      let newData = data?.subdata(in: range)
      print(String(data: newData!, encoding: .utf8)!)
      DispatchQueue.main.async {
        completion(true, nil)
      }
    }
    task.resume()
  }
  
  class func getUserData(accountKey: String , completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getUserData(accountKey).url , responseType: UserData.self, isSecureResponse: true) { (response, error) in
      if let response = response {
        User.userData = response
        completion(true, nil)
      } else {
        completion(true, error)
      }
    }
  }
}
