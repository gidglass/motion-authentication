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

        // Do any additional setup after loading the view.
        
        print("PHONE X:") // TESTING PURPOSES!
        print(phoneData.x) // TESTING PURPOSES!
        
        print("WATCH X:") // TESTING PURPOSES!
        print(watchData.x) // TESTING PURPOSES!
        
        
        // TODO: Convert MotionData objects (watch and phone) into JSON
        // format and prepare for an HTTP request and data processing
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
