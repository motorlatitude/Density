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
    var characters = [[String: Any]]()
    var valueToPass: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        //Handle Pull-to-Refresh
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        //Load Characters
        self.loadCharacters()
        //Register Event Listeners
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "logout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "authenticated"), object: nil)
    }
    
    func refresh(sender: AnyObject){
        //load characters again on refresh
        loadCharacters()
    }
    
    func loadCharacters(){
        characters = [[String: Any]]()
        let api_hander = APIHandler()
        //Adz: 4611686018463007163
        //Me: 4611686018430795740
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "loggedIn") {
            
            let userInfo = defaults.dictionary(forKey: "userInfo")
            let membershipId = userInfo?["membershipId"] as! String
            let membershipType = userInfo?["membershipType"] as! NSNumber
            
            api_hander.getAccountSummary(membershipType: membershipType, membershipId: NSNumber(value: Int(membershipId)!), completion: {
                json in
                let response = json["Response"] as? [String:Any]
                let data_response = response?["data"] as? [String:Any]
                let chars = data_response?["characters"] as! NSArray
                self.numberOfCharacters = self.characters.count
            
                for i in 0 ..< chars.count{
                    var char = chars[i] as! [String: Any]
                    let characterBase = char["characterBase"] as! [String:Any]
                    let raceHash = characterBase["raceHash"] as! NSNumber
                    api_hander.getManifestForType(type: "Race", hash: raceHash, completion: {
                        json in
                        let charRace = (json["Response"] as! [String:Any])["data"] as! [String: Any]
                        char["race"] = charRace
                        //add all characters including race info into characters Array
                        self.characters.append(char)
                        DispatchQueue.main.sync(execute: {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        })
                    })
                }
            })
        }
        else{
            print("User not signed in")
            characters = [[String: Any]]()
            self.numberOfCharacters = 0
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
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
        //Format Table Cell to include emblem, race, etc.
        //NO API REQUESTS SHOULD BE DONE HERE (they will get executed on redraw - can lead to RateLimit violation)
        let char = self.characters[indexPath.row]
        cell.characterData = char
        let characterBase = char["characterBase"] as! [String:Any]
        let classNumber = characterBase["classType"] as! Int
        let className = bungieAPIConstants().classNameForId[classNumber]
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
        let genderNumber = characterBase["genderType"] as! Int
        let genderName = bungieAPIConstants().genderForId[genderNumber]
        let race = ((char["race"] as! [String: Any])["race"] as! [String: Any])["raceName"] as! String
        cell.raceGenderLabel?.text = race+" "+genderName
        cell.characterRaceData = char["race"] as? [String: Any]
        
        let characterLevel = char["characterLevel"] as! NSNumber
        let characterLightLevel = characterBase["powerLevel"] as! NSNumber
        cell.characterLevelLabel?.text = String(describing: characterLevel)
        cell.characterLightLevelLabel?.text = "◆ " + String(describing: characterLightLevel)
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //Switch to Profile View
        print("Switching Segue")
        if (segue.identifier == "profileSegue") {
            print("Switch profileSegue")
            let svc = segue.destination as! profileViewController
            let cell = sender as! characterTableViewCell
            svc.characterData = cell.characterData
            svc.characterRaceData = cell.characterRaceData
        }
        
    }
 

}
