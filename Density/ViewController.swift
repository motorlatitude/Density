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
        
        let urlString = "https://www.bungie.net/Platform/Destiny/2/Account/4611686018463007163/Summary/"
        let myUrl = URL(string: urlString);
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "GET"
        request.addValue("5129cf2f821e410daf3a86c1d8a03499", forHTTPHeaderField: "X-API-Key")
        request.addValue("Density", forHTTPHeaderField: "User-Agent")
        print(request.allHTTPHeaderFields)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
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
            }
            catch{
                print(error)
            }
        }
        task.resume()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
//cheeeeeeeeeeese
