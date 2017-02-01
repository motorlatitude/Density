//
//  loginHandler.swift
//  Density
//
//  Created by Lennart Hase on 31/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import Foundation

class loginHandler{
    
    func authTokenRecieved(authorizationToken: String){
        print("loginHander recieved token")
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
                        if destinyAccounts.count < 0 {
                            print("User has not got a Xbox or PS4 destiny account")
                        }
                        else{
                            for i in 0 ..< destinyAccounts.count {
                                let membershipType = ((destinyAccounts[i] as! [String: Any])["userInfo"] as! [String: Any])["membershipType"] as! Int
                                if defaults.integer(forKey: "membershipType") == membershipType {
                                    //account type found, user likely wants characters from this account
                                    let userInfo = (destinyAccounts[i] as! [String: Any])["userInfo"] as! [String: Any]
                                    defaults.setValue(userInfo, forKey: "userInfo")
                                }
                            }
                            if defaults.dictionary(forKey: "userInfo") == nil {
                                //error
                                self.logout()
                                print("[Error] No userInfo stored, logging out")
                                DispatchQueue.main.sync(execute: {
                                    //send authenticationError event throughout app
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticationError"), object: nil)
                                })
                                
                            }
                            else{
                                DispatchQueue.main.sync(execute: {
                                    //send authenticated event throughout app
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authenticated"), object: nil)
                                })
                            }
                        }
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
    
    func logout(){
        //Clear all stored value
        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: "accessToken")
        defaults.setValue(nil, forKey: "accessTokenExpires")
        defaults.setValue(false, forKey: "loggedIn")
        defaults.setValue(nil, forKey: "refreshToken")
        defaults.setValue(nil, forKey: "refreshTokenExpires")
        defaults.setValue(nil, forKey: "userInfo")
        defaults.setValue(nil, forKey: "membershipType")
        //send logout event throughout app
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
    }
    
}
