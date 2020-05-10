//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct UserData : Codable {
  let key: String
  let lastName: String
  let firstName: String
  let nickname: String
  let imageUrl: String
  
  enum CodingKeys: String, CodingKey {
    case lastName = "last_name"
    case firstName = "first_name"
    case imageUrl = "_image_url"
    case key
    case nickname
  }
}
