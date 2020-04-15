//
//  PostPinViewController.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/15/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

    import Foundation
    import UIKit
    import MapKit

     class PostPinViewController: UIViewController, MKMapViewDelegate {
        var coordinates: CLLocationCoordinate2D!
        @IBOutlet weak var mapView: MKMapView!
        
        override func viewDidLoad() {
            print(coordinates)
            
            // Geocode cooridinates
            var annotations = [MKPointAnnotation]()
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
            
            let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.mapView.setRegion(region, animated: true)
        }
}
