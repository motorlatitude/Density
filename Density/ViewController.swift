//
//  ViewController.swift
//  Density
//
//  Created by Lennart Hase on 27/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emblem: UIImageView?
    @IBOutlet weak var emblemIcon: UIImageView?
    @IBOutlet weak var classNameLabel: UILabel?
    @IBOutlet weak var raceGenderLabel: UILabel?
    @IBOutlet weak var characterLevelLabel: UILabel?
    @IBOutlet weak var characterLightLevelLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api_hander = APIHandler()
        api_hander.getAccountSummary(membershipType: 2, membershipId: 4611686018430795740, completion: {
            json in
            let response = json["Response"] as? [String:Any]
            let data_response = response?["data"] as? [String:Any]
            let characters: NSArray = data_response?["characters"] as! NSArray
            let firstCharacter = characters[0] as? [String:Any]
            for i in 0 ..< characters.count {
                let character = characters[i] as! [String: Any]
                print(character["characterLevel"]!)
            }
            if((firstCharacter?["backgroundPath"]) != nil){
                do{
                    print(firstCharacter?["backgroundPath"] as! String)
                    var emblemURLString = "https://www.bungie.net/"
                    emblemURLString += firstCharacter?["backgroundPath"] as! String
                    let emblem_url = URL(string: emblemURLString)
                    let emblemImg = try UIImage(data: Data(contentsOf: emblem_url!))
                    
                    var emblemIconURLString = "https://www.bungie.net/"
                    emblemIconURLString += firstCharacter?["emblemPath"] as! String
                    let emblemIcon_url = URL(string: emblemIconURLString)
                    let emblemIconImg = try UIImage(data: Data(contentsOf: emblemIcon_url!))
                    
                    DispatchQueue.main.sync(execute: {
                        self.emblem?.image = emblemImg
                        self.emblemIcon?.image = emblemIconImg
                    })
                }
                catch{
                    print("Could not retrieve emblem")
                }
            }
            let characterLevel = firstCharacter?["characterLevel"] as! NSNumber
            print(characterLevel)
            let characterBase = firstCharacter?["characterBase"] as? [String:Any]
            let characterLightLevel = characterBase?["powerLevel"] as! NSNumber
            let genderNumber = characterBase?["genderType"] as! NSNumber
            let raceHash = characterBase?["raceHash"] as! NSNumber
            var genderName = "Female"
            if genderNumber == 0 {
                genderName = "Male"
            }
            print(genderName)
            let classNumber = characterBase?["classType"] as! Int
            let className = bungieAPIConstants().classNameForId[classNumber]
            print(className)
            api_hander.getManifestForType(type: "Race", hash: raceHash, completion: {
                json in
                let race = (((json["Response"] as! [String:Any])["data"] as! [String: Any])["race"] as! [String: Any])["raceName"] as! String
                DispatchQueue.main.sync(execute: {
                    self.classNameLabel?.text = className
                    self.raceGenderLabel?.text = race+" "+genderName
                    self.characterLevelLabel?.text = String(describing: characterLevel)
                    self.characterLightLevelLabel?.text = "◆ " + String(describing: characterLightLevel)
                })
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

