//
//  settingsTableViewController.swift
//  Density
//
//  Created by Lennart Hase on 30/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

//In charge of settings tableview
//Also handles OAuth for Authorization

import UIKit
import SafariServices

class settingsTableViewController: UITableViewController {

    @IBOutlet weak var account: UITableViewCell?
    var loggingIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        //check if user has loggedIn status
        if defaults.bool(forKey: "loggedIn") {
            self.account?.textLabel?.text = "Sign Out"
            loggingIn = false
        }
        else{
            self.account?.textLabel?.text = "Authenticate"
            loggingIn = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        let defaults = UserDefaults.standard
        let login_handler = loginHandler()
        if selectedCell.reuseIdentifier == "account" {
            if !defaults.bool(forKey: "loggedIn") {
                print("Authenticate Selected")
                loggingIn = true
                NotificationCenter.default.addObserver(self, selector: #selector(self.loggedIn), name: NSNotification.Name(rawValue: "authenticated"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.authenticationError), name: NSNotification.Name(rawValue: "authenticationError"), object: nil)
            }
            else {
                //logout
                login_handler.logout()
                loggingIn = true
                self.account?.textLabel?.text = "Authenticate"
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loggedIn(notification: NSNotification){
        loggingIn = false
        self.dismiss(animated: true)
        self.account?.textLabel?.text = "Sign Out"
    }
    
    func authenticationError(notification: NSNotification){
        let alert = UIAlertController(title: "Authentication Error", message: "Failed to log you in, please try again", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else{
            return 2
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "authenticationSegue" {
            if loggingIn == true {
                return true
            }
            return false
        }
        return true
    }
 

}
