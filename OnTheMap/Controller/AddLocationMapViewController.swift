//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 03/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {
  var mapDelegate = MapDelegate()
  var newLocation: CLLocation!
  var newLocationName: String!
  var newUrl: String!
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var finishButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = mapDelegate
    
    let pinNewLocation = StudentPin(firstName: User.userData.firstName, lastName: User.userData.lastName, coordinate: newLocation.coordinate, locationName: newLocationName, url: newUrl, updatedAt: Date().description)
    
    mapView.addAnnotation(pinNewLocation)
    mapView.centerToLocation(newLocation)
  }
  
  
  @IBAction func handleFinishButton(_ sender: Any) {
    APIClient.postStudentLocation(mapString: newUrl, mediaURL: newUrl, latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude) { (success, error) in
      if(success) {
        APIClient.getStudentLocation { (success, error) in
          if success {
            NotificationCenter.default.post(name: Notification.Name.RefreshData, object: nil)
          } else {
            self.showAlertMessage(title: "Error", message: "Impossible to update student locations" )
          }
        }
        self.dismiss(animated: true, completion: nil)
      }
      else  {
        self.showAlertMessage(title: "Error", message: "Impossible to post your location" )
        return
      }
    }
  }
}
