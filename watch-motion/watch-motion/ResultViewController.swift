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
        http.POST("http://10.128.10.207:8000/checkSync/", requestJSON: requestJSON!, postComplete: {(success: Bool, msg: String) in
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    self.statusLabel.text = "Match!"
                } else {
                    self.statusLabel.text = "Doesn't Match!"
                }
            }
        })
        
        // TODO: Also send message to watch to update UI
        
        // Print to console for debugging
//        print("JSON DATA:")
        print(self.watchData.x.count)
//        print(NSString(data: requestJSON!, encoding: NSUTF8StringEncoding) as! String, "\n")
        
    }
}
