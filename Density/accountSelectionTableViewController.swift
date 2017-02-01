//
//  accountSelectionTableViewController.swift
//  Density
//
//  Created by Lennart Hase on 31/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit
import SafariServices

class accountSelectionTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NotificationCenter.default.addObserver(self, selector: #selector(self.authUpdate), name: NSNotification.Name(rawValue: "authenticated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.authUpdate), name: NSNotification.Name(rawValue: "authenticationError"), object: nil)
    }
    
    func authUpdate(){
        print("authUpdate")
        dismiss(animated: true)
        self.navigationController?.popViewController(animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        let defaults = UserDefaults.standard
        var signin_url = "https://www.bungie.net/en/User/SignIn/Psnid?bru=%252fen%252fApplication%252fAuthorize%252f11275"
        if selectedCell.reuseIdentifier == "PSN" {
            print("PSN")
            signin_url = "https://www.bungie.net/en/User/SignIn/Psnid?bru=%252fen%252fApplication%252fAuthorize%252f11275"
            defaults.setValue(2, forKey: "membershipType")
        }
        else{
            print("XBOX")
            signin_url = "https://www.bungie.net/en/User/SignIn/Xuid?bru=%252fen%252fApplication%252fAuthorize%252f11275"
            defaults.setValue(1, forKey: "membershipType")
        }
        let svc = SFSafariViewController(url: URL(string: signin_url)!)
        svc.delegate = self
        svc.preferredBarTintColor = UIColor(red:0.10, green:0.11, blue:0.13, alpha:1.00)
        svc.preferredControlTintColor = UIColor(red:0.95, green:0.81, blue:0.19, alpha:1.00)
        present(svc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Closed SFSafariViewController")
        dismiss(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
