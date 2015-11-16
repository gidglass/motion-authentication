//
//  ResultViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/6/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var restartButton: UIBarButtonItem!
    
    var phoneData: MotionData!
    var watchData: MotionData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Convert MotionData to JSON format
        let phoneJSON = phoneData.toJSON()
        let watchJSON = watchData.toJSON()
        
        // Print to console for debugging
        print("PHONE DATA:")
        print(NSString(data: phoneJSON!, encoding: NSUTF8StringEncoding) as! String, "\n")
        
        print("WATCH DATA:")
        print(NSString(data: watchJSON!, encoding: NSUTF8StringEncoding) as! String,  "\n")
        
        // TODO: Make HTTP POST request and get authentication status as response
        // Update status label to reflect, "Success" or "Failure"

    }
}
