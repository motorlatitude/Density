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

class settingsTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        if selectedCell.reuseIdentifier == "auth" {
            print("Authenticate Selected")
            let svc = SFSafariViewController(url: URL(string: "https://www.bungie.net/en/Application/Authorize/11275")!)
            svc.delegate = self
            //add observer for authenticationComplete event
            NotificationCenter.default.addObserver(self, selector: #selector(self.authTokenRecieved), name: NSNotification.Name(rawValue: "authenticationComplete"), object: nil)
            present(svc, animated: true)
        }
        else if selectedCell.reuseIdentifier == "logout" {
            //Clear all stored values
            let defaults = UserDefaults.standard
            defaults.setValue(nil, forKey: "accessToken")
            defaults.setValue(nil, forKey: "accessTokenExpires")
            defaults.setValue(false, forKey: "loggedIn")
            defaults.setValue(nil, forKey: "refreshToken")
            defaults.setValue(nil, forKey: "refreshTokenExpires")
            defaults.setValue(nil, forKey: "userInfo")
            //send logout event throughout app
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func authTokenRecieved(notification: NSNotification){
        let authorizationToken = notification.object as! String
        let defaults = UserDefaults.standard
        //Recieve the token from app url density://callback?code={authorization_token} (see AppDelegate)
        print("Authentication Token Recieved: "+authorizationToken)
        //Retrieve AccessToken and RefreshToken
        let myURL = URL(string: "https://www.bungie.net/Platform/App/GetAccessTokensFromCode/")
        let request = NSMutableURLRequest(url: myURL!)
        request.httpMethod = "POST"
        request.addValue("b7566f71709945619e01fcab426f01cd", forHTTPHeaderField: "X-API-Key")
        request.addValue("Density", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let jsonData = "{\"code\": \""+authorizationToken+"\",\"grant_type\": \"authorization_code\"}"
        let requestData = jsonData.data(using: .utf8)!
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if (error != nil){
                print(error!)
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                if (json != nil){
                    let response = json?["Response"] as! [String: Any]
                    let accessToken = (response["accessToken"] as! [String: Any])["value"] as! String
                    let accessTokenExpire = NSDate().timeIntervalSince1970 + 3600 //set standard 1hr valid
                    print(accessTokenExpire)
                    //store values in UserDefaults for retrieval later
                    defaults.setValue(accessToken, forKey: "accessToken")
                    defaults.setValue(accessTokenExpire, forKey: "accessTokenExpires")
                    defaults.setValue(true, forKey: "loggedIn")
                    let refreshToken = (response["accessToken"] as! [String: Any])["value"] as! String
                    let refreshTokenExpire = NSDate().timeIntervalSince1970 + 7776000 //90 days
                    defaults.setValue(refreshToken, forKey: "refreshToken")
                    defaults.setValue(refreshTokenExpire, forKey: "refreshTokenExpires")
                    //get the membershipId and membershipType for accessToken and store
                    AuthAPIHandler().getCurrentBungieAccount(completion: {
                        json in
                        let response = json["Response"] as! [String: Any]
                        let destinyAccounts = response["destinyAccounts"] as! NSArray
                        let firstDestinyAccount = destinyAccounts[0] as! [String: Any]
                        let userInfo = firstDestinyAccount["userInfo"] as! [String: Any]
                        defaults.setValue(userInfo, forKey: "userInfo")
                        
                        DispatchQueue.main.sync(execute: {
                            self.dismiss(animated: true)
                            //send authenticated event throughout app
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticated"), object: nil)
                        })
                    })
                }
                else{
                    print("JSON Parsing Error")
                }
            }
            catch{
            
            }
        }
        task.resume()
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Closed SFSafariViewController")
        dismiss(animated: true)
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
