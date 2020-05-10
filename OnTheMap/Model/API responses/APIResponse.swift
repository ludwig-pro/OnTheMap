//
//  APIResponse.swift
//  OnTheMap
//
//  Created by ludwig vantours on 29/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
  let statusCode: Int
  let statusMessage: String
  
  enum CodingKeys: String, CodingKey {
    case statusCode = "status_code"
    case statusMessage = "status_message"
  }
}

extension APIResponse: LocalizedError {
  var errorDescription: String? {
    return statusMessage
  }
}
