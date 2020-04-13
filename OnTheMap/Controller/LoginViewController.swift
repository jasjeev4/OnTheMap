//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/11/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onLoginInit(_ sender: Any) {
        // Get username and password
        let username = usernameField.text!
        let password = passwordField.text!
        
        
        OnTheMapClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
        
        
        
       // LoginSession().login(username: username, password: password)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print(OnTheMapClient.Auth.uniqueKey)
            
            // Load user pins
            OnTheMapClient.loadPins(completion: handlePinsResponse(success:error:))
            
            // Perform segue to MapView
            // performSegue(withIdentifier: "toMapView", sender: nil)
        }
        else {
            print("There was an error")
        }
    }
    
    func handlePinsResponse(success: Bool, error: Error?) {
        if success {
            print("Done")
        }
        else {
            print("There was an error")
        }
    }
    
//    func handleRequestTokenResponse(success: Bool, error: Error?) {
//        if success {
//            print(success)
//        } else {
//            print(error)
//        }
//    }
    
}

