//
//  APIHandler.swift
//  Density
//
//  Created by Adam Knight on 29/01/2017.
//  Copyright © 2017 Adam Knight. All rights reserved.
//

import Foundation

class APIHandler {
    let host = "https://www.bungie.net/platform/destiny/"
    func getAccountSummary(membershipType: NSNumber, membershipID: NSNumber, completion: @escaping ([String:Any]) -> ()) {
        let endpoint_url = host + String(describing: membershipType) + "/Account/" + String(describing: membershipID) + "/Summary/"
        self.sendRequest(endpoint_url: endpoint_url, completion: completion)
    }
    func sendRequest(endpoint_url: String, completion: @escaping ([String:Any]) -> ()){
        let myURL = URL(string: endpoint_url)
        let request = NSMutableURLRequest(url:myURL!)
        request.httpMethod = "GET"
        request.addValue("5129cf2f821e410daf3a86c1d8a03499", forHTTPHeaderField: "X-API-Key")
        request.addValue("Density", forHTTPHeaderField: "User-Agent")
        print(request.allHTTPHeaderFields)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? [String:Any]
                completion(json!)
            }
            catch{
                print("Request Error")
            }
        }
    }
}
