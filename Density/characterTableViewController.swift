//
//  characterTableViewController.swift
//  Density
//
//  Created by Lennart Hase on 29/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class characterTableViewController: UITableViewController {

    var numberOfCharacters: Int = 0
    var characters: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        let api_hander = APIHandler()
        //Adz: 4611686018463007163
        //Me: 4611686018430795740
        api_hander.getAccountSummary(membershipType: 2, membershipId: 4611686018430795740, completion: {
            json in
            let response = json["Response"] as? [String:Any]
            let data_response = response?["data"] as? [String:Any]
            self.characters = data_response?["characters"] as! NSArray
            self.numberOfCharacters = self.characters.count
            DispatchQueue.main.sync(execute: {
                self.tableView.reloadData()
            })
            /*
            for i in 0 ..< characters.count {
                let character = characters[i] as! [String: Any]
                print(character["characterLevel"]!)
            }*/
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.characters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterTableViewCell", for: indexPath) as! characterTableViewCell
        
        let char = self.characters[indexPath.row] as! [String:Any]
        let characterBase = char["characterBase"] as! [String:Any]
        let classNumber = characterBase["classType"] as! NSNumber
        var className = ""
        if classNumber == 0 {
            className = "Titan"
        }
        else if classNumber == 1{
            className = "Hunter"
        }
        else{
            className = "Warlock"
        }
        print(className)
        cell.classNameLabel?.text = className
        if((char["backgroundPath"]) != nil){
            do{
                print(char["backgroundPath"] as! String)
                var emblemURLString = "https://www.bungie.net/"
                emblemURLString += char["backgroundPath"] as! String
                let emblem_url = URL(string: emblemURLString)
                let emblemImg = try UIImage(data: Data(contentsOf: emblem_url!))
                
                var emblemIconURLString = "https://www.bungie.net/"
                emblemIconURLString += char["emblemPath"] as! String
                let emblemIcon_url = URL(string: emblemIconURLString)
                let emblemIconImg = try UIImage(data: Data(contentsOf: emblemIcon_url!))
                cell.emblem?.image = emblemImg
                cell.emblemIcon?.image = emblemIconImg
            }
            catch{
                print("Could not retrieve emblem")
            }
        }
        let genderNumber = characterBase["genderType"] as! NSNumber
        let raceHash = characterBase["raceHash"] as! NSNumber
        var genderName = "Female"
        if genderNumber == 0 {
            genderName = "Male"
        }
        let api_hander = APIHandler()
        api_hander.getManifestForType(type: "Race", hash: raceHash, completion: {
            json in
            let race = (((json["Response"] as! [String:Any])["data"] as! [String: Any])["race"] as! [String: Any])["raceName"] as! String
            DispatchQueue.main.sync(execute: {
                cell.raceGenderLabel?.text = race+" "+genderName
            })
        })
        
        let characterLevel = char["characterLevel"] as! NSNumber
        let characterLightLevel = characterBase["powerLevel"] as! NSNumber
        cell.characterLevelLabel?.text = String(describing: characterLevel)
        cell.characterLightLevelLabel?.text = "◆ " + String(describing: characterLightLevel)
        
        return cell
    }

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
