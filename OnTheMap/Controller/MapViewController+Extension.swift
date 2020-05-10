//
//  MapViewController+Extension.swift
//  OnTheMap
//
//  Created by ludwig vantours on 08/05/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
  
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 5000000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

class MapDelegate: NSObject, MKMapViewDelegate {

  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {

    guard let annotation = annotation as? StudentPin else {
      return nil
    }
  
    let identifier = "studenPin"
    var view: MKMarkerAnnotationView

    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {

      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
  
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    guard let studentAnnotation = view.annotation else {
      return
    }
    let url = URL(string: studentAnnotation.subtitle!!)!
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      let googleSearch = URL(string: "https://www.google.com/search?q=\(studentAnnotation.subtitle!!)")!
       UIApplication.shared.open(googleSearch, options: [:], completionHandler: nil)
    }
  }
}
