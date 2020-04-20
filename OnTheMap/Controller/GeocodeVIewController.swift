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
    @IBOutlet weak var locationField: UITextField!
    var coordinates: CLLocationCoordinate2D!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(GeocodeViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        subscripbeToKeyboardNotifications()
        activityIndicator.hidesWhenStopped = true
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.dismiss(animated: true)
    }
    
    func subscripbeToKeyboardNotifications() {
        // On Keyboard show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // On keyboard hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
            // Move rest of the view to make room for keyboard
            
            view.frame.origin.y = -getKeyboardHeight(notification)
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        // check if result can be geocoded
        activityIndicator.startAnimating()
        OnTheMapClient.getCoordinate(addressString: locationField.text!, completionHandler: handGeoencodeResponse(coordinates:error:))
    }
    
    func handGeoencodeResponse(coordinates: CLLocationCoordinate2D, error: NSError?) {
        activityIndicator.stopAnimating()
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
