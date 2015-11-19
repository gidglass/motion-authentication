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
    @IBOutlet weak var statusLabel: UILabel!
    
    var phoneData: MotionData!
    var watchData: MotionData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Convert MotionData to JSON format
        let data = ["phone": phoneData.toDictionary(), "watch": watchData.toDictionary()]
        
        // Make HTTP request
        let http = HTTP()
        let requestJSON = http.toJSON(data)
        http.POST("URL_GOES_HERE", requestJSON: requestJSON!, postComplete: {(success: Bool, msg: String) in
            if success {
                self.statusLabel.text = "Success!"
            } else {
                self.statusLabel.text = "Failure!"
            }
        })
        
        // TODO: Also send message to watch to update UI
        
        // Print to console for debugging
        print("JSON DATA:")
        print(NSString(data: requestJSON!, encoding: NSUTF8StringEncoding) as! String, "\n")
        
    }
}
