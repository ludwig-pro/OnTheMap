//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by ludwig vantours on 10/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
  let status: Int
  let error: String
}

extension ErrorResponse: LocalizedError {
  var errorDescription: String? {
    return error
  }
}
