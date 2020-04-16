//
//  GeocodeVIewController.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/15/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class GeocodeViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationField: UITextField!
    var coordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(GeocodeViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        // check if result can be geocoded
        OnTheMapClient.getCoordinate(addressString: locationField.text!, completionHandler: handGeoencodeResponse(coordinates:error:))
        
        
    }
    
    func handGeoencodeResponse(coordinates: CLLocationCoordinate2D, error: NSError?) {
        if(error != nil) {
            failureAlert(title: "Invalid address", message: "Couldn't find that location")
        }
        else {
            self.coordinates = coordinates
            performSegue(withIdentifier: "toLinkMap", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PostPinViewController
        if let coordinates =  coordinates {
            vc.self.coordinates = coordinates
            vc.self.location = locationField.text
        }
        else {
            print("Location not set")
        }
    }
    
    func failureAlert(title: String, message: String) {
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertVC, animated: true, completion: nil)

    }
    
}
