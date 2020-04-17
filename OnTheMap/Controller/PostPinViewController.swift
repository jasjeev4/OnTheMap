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
    @IBOutlet weak var URLField: UITextField!
    var location: String!
    
    override func viewDidLoad() {
        // Geocode cooridinates
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotations.append(annotation)
        self.mapView.addAnnotations(annotations)
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapView.setRegion(region, animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))

    }
    
    @objc func submitTapped(){
        print("Submit tappedd")
        
        // Send details to mode
        uploadPinHelper(coordinates: coordinates, location: location, mediaURL: URLField.text!)
        
    }
    
    func uploadPinHelper(coordinates: CLLocationCoordinate2D, location: String, mediaURL: String) {
        // load user's name
        let firstName = OnTheMapClient.Auth.nickname
        let lastName = ""
        
        let obj = PinPost(uniqueKey: OnTheMapClient.Auth.uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL, mapString: location, latitude: coordinates.latitude, longitude: coordinates.longitude)
        OnTheMapClient.postPin(body: obj) { (success, error) in
            if success {
                print("Success")
                // self.alertMsg(title: "Posted pin", message: "Your pin was posted")
                // Go back to the previous ViewController
                self.navigationController?.dismiss(animated: true)
            }
            else {
                // alertMsg(title: "Failed", message: "Failed to post pin")
            }
        }
    }
    
    func alertMsg(title: String, message: String) {
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertVC, animated: true, completion: nil)
    }
}
