//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 30/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController {
  var mapDelegate = MapDelegate()
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let navigationBar = navigationController
    navigationBar?.isNavigationBarHidden = false
    mapView.delegate = mapDelegate
    let initialLocation = CLLocation(latitude: 41.360686, longitude: -103.730694) // center to USA
    mapView.centerToLocation(initialLocation)
    addAnnotations()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name.RefreshData, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.RefreshData, object: nil)
  }
  
  
  func addAnnotations() {
    var annotations = [MKAnnotation]()
    let studentLocations = Students.locations
    
    for student in studentLocations {
      let pin = StudentPin(firstName: student.firstName, lastName: student.lastName, coordinate: CLLocationCoordinate2D.init(latitude: student.latitude, longitude: student.longitude), locationName: student.mapString, url: student.mediaURL, updatedAt: student.updatedAt)
      
      annotations.append(pin)
    }
    
    self.mapView.addAnnotations(annotations)
  }
  
  @objc func refreshData(){
    DispatchQueue.main.async {
      let annotationsToDelete = self.mapView.annotations
      self.mapView.removeAnnotations(annotationsToDelete)
      self.addAnnotations()
    }
    
  }
}

