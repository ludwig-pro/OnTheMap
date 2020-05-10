//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
  let account: Account
  let session: Session
}

struct Session: Codable {
  var id : String!
  var expiration: String!
}

struct Account: Codable {
  var registered: Bool!
  var key: String!
}
