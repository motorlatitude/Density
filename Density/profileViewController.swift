//
//  profileViewController.swift
//  Density
//
//  Created by Lennart Hase on 30/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {

    var characterData: [String: Any]? = [:]
    var characterRaceData: [String: Any]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let characterBase = characterData?["characterBase"] as! [String:Any]
        let classNumber = characterBase["classType"] as! Int
        let className = bungieAPIConstants().classNameForId[classNumber]
        let titleView = self.navigationItem.titleView as! profileTitleBarView
        titleView.titleLabel.text = "Profile"
        titleView.characterLabel.text = className+" // "+String(describing: characterData?["characterLevel"] as! NSNumber)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
