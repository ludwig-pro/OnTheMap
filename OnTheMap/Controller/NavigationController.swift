//
//  NavigationController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 07/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit

class NavigationViewController: UITabBarController {
  
  @IBAction func LogoutButton(_ sender: Any) {
    APIClient.deleteUserSession { (success, error) in
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func refreshStudentLocations(_ sender: Any) {
    APIClient.getStudentLocation { (success, error) in
      if success {
        print("updated student location")
         NotificationCenter.default.post(name: Notification.Name.RefreshData, object: nil)
      } else {
        self.showAlertMessage(title: "Error", message: "Impossible to update student locations" )
      }
    }
  }
}

extension Notification.Name {
  public static let RefreshData = Notification.Name("RefreshData")
}
