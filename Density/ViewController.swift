//
//  ViewController.swift
//  Density
//
//  Created by Adam Knight on 27/01/2017.
//  Copyright © 2017 Adam Knight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lightLevelLabel: UILabel?
    @IBOutlet weak var classGenderNameLabel: UILabel?
    @IBOutlet weak var emblem: UIImageView?
    @IBOutlet weak var background: UIImageView?
    @IBOutlet weak var character: UILabel?

    override func viewDidLoad() {
        let api_handler = APIHandler()
        api_handler.getAccountSummary(membershipType: 2, membershipID: 4611686018463007163, completion: {
            json in
            // Calls the getAccountSummary method using given variables to return JSON data. TODO add functionality later to enter membershipType and membershipType from user-given info.
            let response = json["Response"] as! [String:Any]
            let data_response = response["data"] as? [String:Any]
            let characters: NSArray = data_response?["characters"] as! NSArray
            print(characters)
            let firstCharacter = characters[0] as? [String:Any]
            let characterBase = firstCharacter?["characterBase"] as? [String:Any]
            let lightLevel = characterBase?["powerLevel"] as! NSNumber
            
            if((firstCharacter?["emblemPath"]) != nil) {
                do {
                    let emblemPath = firstCharacter?["emblemPath"] as! NSString
                    let emblemURL = "https://www.bungie.net"
                    let emblemImageString = emblemURL + String(describing: emblemPath)
                    let emblemImageURL = URL(string: emblemImageString)
                    let emblemImage = try UIImage(data: Data(contentsOf: emblemImageURL!))
                    print(emblemImageURL)
                    
                    let backgroundPath = firstCharacter?["backgroundPath"] as! NSString
                    let backgroundImageString = emblemURL + String(describing: backgroundPath)
                    let backgroundImageURL = URL(string: backgroundImageString)
                    let backgroundImage = try UIImage(data: Data(contentsOf: backgroundImageURL!))
                    print(backgroundImageURL)
                    
                    DispatchQueue.main.sync(execute: {
                        self.emblem?.image = emblemImage
                        self.background?.image = backgroundImage
                    })
                }
                catch {
                    print("Shit son, no emblem")
                }
            }
            
            let genderNumber = characterBase?["genderType"] as! NSNumber
            var genderName = "Female"
            if genderNumber == 0 {
                genderName = "Male"
            }
            print(genderName)
            let classNumber = characterBase?["classType"] as! NSNumber
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
            let classGenderName = genderName + " " + className
            print(classGenderName)
            let raceHashNumber = characterBase?["raceHash"] as! NSNumber
            
       
            api_handler.getRace(raceHash: raceHashNumber, completion: {
                json in
                let response = json["Response"] as! [String:Any]
                let data_response = response["data"] as? [String:Any]
                let race = data_response?["race"] as? [String:Any]
                let raceName = race?["raceName"] as! NSString
                print(raceName)
                
                let characterDetails = String(describing: raceName) + " " + classGenderName
                
                DispatchQueue.main.sync(execute: {
                    self.lightLevelLabel?.text = String(describing: lightLevel)
                    self.classGenderNameLabel?.text = String(describing: classGenderName)
                    self.character?.text = String(describing: characterDetails)
                })
                
            })
        })
    }
        // Do any additional setup after loading the view, typically from a nib.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}    // Dispose of any resources that can be recreated.
