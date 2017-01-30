//
//  APIHandler.swift
//  Density
//
//  Created by Lennart Hase on 29/01/2017.
//  Copyright © 2017 Lennart Hase. All rights reserved.
//

import Foundation

class APIHandler {
    
    let host = "https://www.bungie.net/Platform/Destiny/"

    func getAccountSummary(membershipType: NSNumber, membershipId: NSNumber, completion: @escaping ([String: Any]) -> ()){
        let endpoint_url = host + String(describing: membershipType) + "/Account/" + String(describing: membershipId) + "/Summary/"
        self.sendRequest(endpoint_url: endpoint_url, completion: completion)
    }
    
    func getManifestForType(type: String, hash: NSNumber, completion: @escaping ([String: Any]) -> ()){
        let endpoint_url = host + "Manifest/" + type + "/" + String(describing: hash) + "/"
        self.sendRequest(endpoint_url: endpoint_url, completion: completion)
    }
    
    func sendRequest(endpoint_url: String, completion: @escaping ([String: Any]) -> ()){
        print("Sending Request => "+endpoint_url)
        let myURL = URL(string: endpoint_url)
        let request = NSMutableURLRequest(url: myURL!)
        request.httpMethod = "GET"
        request.addValue("b7566f71709945619e01fcab426f01cd", forHTTPHeaderField: "X-API-Key")
        request.addValue("Density", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if (error != nil){
                print(error)
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                if (json != nil){
                    completion(json!)
                }
                else{
                    print("JSON Parsing Error")
                }
            }
            catch{
                print("Request Error")
            }
        }
        task.resume()
    }
    
}
