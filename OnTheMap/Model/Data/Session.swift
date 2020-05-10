//
//  Session.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import Foundation

class User {
  static var account = Account(registered: false, key: "")
  static var session = Session(id: "", expiration: "")
  static var userData = UserData(key: "", lastName: "", firstName: "", nickname: "", imageUrl: "")
}
