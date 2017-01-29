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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api_hander = APIHandler()
        api_hander.getAccountSummary(membershipType: 2, membershipId: 4611686018463007163, completion: {
            json in
            let response = json["Response"] as? [String:Any]
            let data_response = response?["data"] as? [String:Any]
            let characters: NSArray = data_response?["characters"] as! NSArray
            let firstCharacter = characters[0] as? [String:Any]
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
            let characterBase = firstCharacter?["characterBase"] as? [String:Any]
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
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

