//
//  postStudentLocationRequest.swift
//  OnTheMap
//
//  Created by ludwig vantours on 29/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let mediaURL: String
  let latitude: Double
  let longitude: Double
  
}
