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
    var raceHashName: String? = ""
    override func viewDidLoad() {
        let api_handler = APIHandler()
        api_handler.getAccountSummary(membershipType: 2, membershipID: 4611686018463007163, completion: {
            json in
            let response = json["Response"] as! [String:Any]
            let data_response = response["data"] as? [String:Any]
            let characters: NSArray = data_response?["characters"] as! NSArray
            print(characters)
            let firstCharacter = characters[0] as? [String:Any]
            let characterBase = firstCharacter?["characterBase"] as? [String:Any]
            let lightLevel = characterBase?["powerLevel"] as! NSNumber
            
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
            
            DispatchQueue.main.sync(execute: {
                self.lightLevelLabel?.text = String(describing: lightLevel)
                self.classGenderNameLabel?.text = String(describing: classGenderName)
                self.raceHashName? = String(describing: raceHashNumber)
            })
        })
        super.viewDidLoad()
    }
        // Do any additional setup after loading the view, typically from a nib.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}    // Dispose of any resources that can be recreated.
