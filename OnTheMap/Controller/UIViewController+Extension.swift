//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by ludwig vantours on 07/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//
import UIKit
import Network



class NetInfo {
  
  let monitor = NWPathMonitor()
  
  func isInternetReachable() -> Bool {
    var status = false
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        status = true  // online
      }
    }
    return status
  }
}

extension UIViewController {
  
  func showAlertMessage(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true)
  }
  
}
