//
//  StartViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/1/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var getStartedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getStarted(sender: UIButton) {
        performSegueWithIdentifier("getStarted", sender: self)
    }
    
    /* UNWIND SEGUE */
    @IBAction func restart (segue:UIStoryboardSegue) {
        print("Restarting")
    }

}

