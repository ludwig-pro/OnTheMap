//
//  CredentialRequest.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct Udacity: Codable {
  let username: String
  let password: String
}

struct SessionRequest: Codable {
  var udacity: Udacity
}
