//
//  GeocodeVIewController.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/15/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit

class GeocodeViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationField: UITextField!
    
    override func viewDidLoad() {
    }
    @IBAction func submitClicked(_ sender: Any) {
        performSegue(withIdentifier: "toLinkMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PostPinViewController
        if let location = locationField {
            vc.self.location = location.text!
        }
        else {
            print("Location not set")
        }
    }
    
}
