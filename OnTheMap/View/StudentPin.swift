//
//  Student.swift
//  OnTheMap
//
//  Created by ludwig vantours on 02/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import MapKit

class StudentPin: NSObject, MKAnnotation {
  let firstName: String?
  let lastName: String?
  let coordinate: CLLocationCoordinate2D
  let locationName: String?
  let url: String?
  let updatedAt: String?
  
  init(firstName: String?, lastName: String?,coordinate: CLLocationCoordinate2D, locationName: String?, url: String?, updatedAt: String?) {
    self.firstName = firstName
    self.lastName = lastName
    self.coordinate = coordinate
    self.locationName = locationName
    self.url = url
    self.updatedAt = updatedAt
  }
  
  var subtitle: String? {
    return url
  }
  var title: String? {
    return "\(firstName!) \(lastName!)" 
  }
}

