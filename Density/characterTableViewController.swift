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
    var overview: UIView?
    
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
            overview?.removeFromSuperview()
            self.setNeedsFocusUpdate()
            let userInfo = defaults.dictionary(forKey: "userInfo")
            if userInfo != nil {
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
                            if self.characters.count == chars.count{
                                DispatchQueue.main.sync(execute: {
                                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                                    let sections = NSIndexSet(indexesIn: range)
                                    self.tableView.reloadSections(sections as IndexSet, with: .fade)
                                    //self.tableView.reloadData()
                                    self.refreshControl?.endRefreshing()
                                })
                            }
                        })
                    }
                })
            }
            else{
                print("UserInfo Error")
                //Something went wrong retrieving user, logout and let the user try again
                loginHandler().logout()
            }
        }
        else{
            print("User not signed in")
            characters = [[String: Any]]()
            self.numberOfCharacters = 0
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            let screenSize: CGRect = UIScreen.main.bounds
            overview = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            overview?.backgroundColor = UIColor(red:0.10, green:0.11, blue:0.13, alpha:1.00)
            let status = UILabel(frame: CGRect(x:0, y:(screenSize.height/2)-90, width: screenSize.width, height: 50))
            status.text = "No Data\nSign In To Continue"
            status.textAlignment = .center
            status.numberOfLines = 2
            status.textColor = UIColor(red:0.19, green:0.21, blue:0.25, alpha:1.00)
            overview?.addSubview(status)
            self.view.addSubview(overview!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        }
        else{
            return 200
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else{
            return self.characters.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "membershipTypeCell", for: indexPath) as! membershipTypeCell
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "loggedIn") {
                if defaults.integer(forKey: "membershipType") == 2{
                    cell.serviceName?.text = "Playstation"
                    cell.serviceIcon?.image = UIImage(named: "PSN")
                }
                else{
                    cell.serviceName?.text = "XBox Live"
                    cell.serviceIcon?.image = UIImage(named: "XBOX")

                }
                let userInfo = defaults.dictionary(forKey: "userInfo")
                if userInfo != nil{
                    cell.serviceType?.text = userInfo?["displayName"] as? String
                }
                return cell
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "characterTableViewCell", for: indexPath) as! characterTableViewCell
            //Format Table Cell to include emblem, race, etc.
            //NO API REQUESTS SHOULD BE DONE HERE (they will get executed on redraw - can lead to RateLimit violation)
            let bgview = UIView(frame: CGRect(x:0, y:0, width: cell.frame.width, height: cell.frame.height - 8))
            bgview.backgroundColor = UIColor(red:0.16, green:0.18, blue:0.20, alpha:1.00)
            cell.addSubview(bgview)
            cell.sendSubview(toBack: bgview)
            let char = self.characters[indexPath.row]
            cell.characterData = char
            let characterBase = char["characterBase"] as! [String:Any]
            let classNumber = characterBase["classType"] as! Int
            let className = bungieAPIConstants().classNameForId[classNumber]
            print(className)
            cell.classNameLabel?.text = className
            if((char["backgroundPath"]) != nil){
                do{
                    // TODO Fix, currently network request on redraw
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
            let progress = char["percentToNextLevel"] as! Float
            cell.levelProgress?.progress = (100 - progress)/100
            
            let characterLevel = char["characterLevel"] as! NSNumber
            let characterLightLevel = characterBase["powerLevel"] as! NSNumber
            cell.characterLevelLabel?.text = String(describing: characterLevel)
            cell.characterLightLevelLabel?.text = "◆ " + String(describing: characterLightLevel)
            return cell
        }
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
