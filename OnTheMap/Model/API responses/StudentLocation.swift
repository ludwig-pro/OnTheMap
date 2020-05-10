//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by ludwig vantours on 29/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

struct StudentLocation:  Codable {
  let objectId: String
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let latitude: Double
  let longitude: Double
  let createdAt: String
  let updatedAt: String
  let mediaURL: String
  
  var title: String {
    return firstName + " " + lastName
  }
}

// YOU DO NOT HAVE TO WORRY ABOUT PARSING DATE OR ACL TYPES.

