//
//  TableViewController.swift
//  OnTheMap
//
//  Created by JASJEEV on 4/14/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Refresh table contents on view load
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = OnTheMapClient.Auth.students.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! CustomViewCell
        let student = OnTheMapClient.Auth.students[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.nameLabel?.text = student.firstName
        cell.detailLabel?.text = student.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = OnTheMapClient.Auth.students[indexPath.row].mediaURL
        let app = UIApplication.shared
        if(verifyUrl (urlString: url)) {
            app.open(URL(string: url)!)
        }
    }
    
    // Credit https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}

class CustomViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
}
