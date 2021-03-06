//
//  HTTP.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/18/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import Foundation

class HTTP: NSObject {
    
    func POST (url: String, requestJSON: NSData, postComplete: (success: Bool, msg: String) -> ()) {
        // Set up the request object
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = requestJSON
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Initialize session object
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> () in
            
            if data == nil {
                postComplete(success: false, msg: "ERROR")
                print("Error data is nil")
                return
            }

            let parsed = self.fromJSON(data!)
            if let responseData = parsed {
                let success = responseData["status"] as! String
                if (success == "1") {
                    postComplete(success: true, msg: "SUCCESS")
                    print("Success!")
                } else {
                    print(responseData)
                    postComplete(success: false, msg: "FAILURE")
                    print("Failure!")
                }
            } else {
                postComplete(success: false, msg: "ERROR")
                print("Error in response!")
            }
        })
        task.resume()
    }
    
    func toJSON (dict: NSDictionary) -> NSData? {
        if NSJSONSerialization.isValidJSONObject(dict) {
            do {
                let json = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions())
                return json
            } catch let error as NSError {
                print("ERROR: Unable to serialize json, error: \(error)")
            }
        }
        return nil
    }
    
    func fromJSON (JSON: NSData) -> NSDictionary? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(JSON, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        } catch {
            return nil
        }
    }
}
