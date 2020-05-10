//
//  InformationViewController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class AddLocationViewController: UIViewController {
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var LinkField: UITextField!
  @IBOutlet weak var findLocationButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToAddLocationMap" {
      let addLocationMapViewController = segue.destination as! AddLocationMapViewController
      addLocationMapViewController.newLocation = sender as? CLLocation
      addLocationMapViewController.newLocationName = locationField.text!
      addLocationMapViewController.newUrl = LinkField.text!
    }
  }
  
  @IBAction func FindLocation(_ sender: Any) {
    if locationField.text!.isEmpty {
      showAlertMessage(title: "Location is missing", message: "Add a location & link before Find location")
      return
    }
    
    if LinkField.text!.isEmpty {
      showAlertMessage(title: "Link is missing", message: "Add a link before Find location")
      return
    }
    
    getCoordinate(addressString: locationField.text!) { (location, error) in
      if let location = location {
        self.performSegue(withIdentifier: "goToAddLocationMap", sender: location)
      } else {
        self.showAlertMessage(title: "Oups!", message: "We can find a location with this address. Please change the address")
      }
    }
    
    
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func getCoordinate( addressString : String,
                      completionHandler: @escaping(CLLocation?, Error?) -> Void ) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      if error == nil {
        if let placemark = placemarks?[0] {
          let location = placemark.location!
          completionHandler(location, nil)
          return
        }
      }
      completionHandler(nil, error as Error?)
    }
  }
  
}
