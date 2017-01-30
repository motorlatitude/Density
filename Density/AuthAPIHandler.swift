//
//  AuthAPIHandler.swift
//  Density
//
//  Created by Lennart Hase on 30/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import Foundation

class AuthAPIHandler{

    let host = "https://www.bungie.net/Platform/"
    
    func getCurrentBungieAccount(completion: @escaping ([String: Any]) -> ()){
        //Retrieve the current bungie account with all linked PSN / Xbox accounts for the stored accessToken
        let endpoint_url = host+"User/GetCurrentBungieAccount/"
        self.sendAuthRequest(endpoint_url: endpoint_url, completion: completion)
    }
    
    func sendAuthRequest(endpoint_url: String, completion: @escaping ([String: Any]) -> ()){
        print("Sending Auth Request => "+endpoint_url)
        let myURL = URL(string: endpoint_url)
        let request = NSMutableURLRequest(url: myURL!)
        request.httpMethod = "GET"
        request.addValue("b7566f71709945619e01fcab426f01cd", forHTTPHeaderField: "X-API-Key")
        request.addValue("Density", forHTTPHeaderField: "User-Agent")
        let defaults = UserDefaults.standard
        //check if user has loggedIn status
        if defaults.bool(forKey: "loggedIn") {
            //check if access token is still valid
            //TODO if not, should go through refresh - make sure to check expiration of refresh token
            if NSDate().timeIntervalSince1970 >= defaults.double(forKey: "accessTokenExpires") {
                print("Access Token Expired")
            }
            else{
                //add accessToken to Header and call request as normal
                request.addValue("Bearer "+defaults.string(forKey: "accessToken")!, forHTTPHeaderField: "Authorization")
        
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in
                    if (error != nil){
                        print(error!)
                    }
            
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                        if (json != nil){
                            completion(json!)
                        }
                    }
                    catch{
                        print("JSON Parse Error")
                    }
                }
                task.resume()
            }
        }
    }
    
}
