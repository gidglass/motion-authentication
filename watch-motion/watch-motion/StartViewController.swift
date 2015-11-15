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
    @IBOutlet weak var watchImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "grow:", userInfo: checkImage, repeats: false)
    }

    @IBAction func getStarted(sender: UIButton) {
        performSegueWithIdentifier("getStarted", sender: self)
    }
    
    /* ANIMATION */
    
    func grow (timer: NSTimer) {
        let image = timer.userInfo as! UIImageView
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.repeatCount = 0
        animation.autoreverses = true
        animation.toValue = NSNumber(double: 1.2)
        image.layer.addAnimation(animation, forKey: "transform.scale")
    }

    
//    func rotate (image: UIImageView, startAngle: Double, endAngle: Double) {
//        let animation = CABasicAnimation(keyPath: "transform.rotation")
//        animation.duration = 0.2
//        animation.repeatCount = 1
//        animation.autoreverses = true
//        animation.fromValue = ((0.0 * CGFloat(M_PI)) / 180.0)
//        animation.toValue = ((30.0 * CGFloat(M_PI)) / 180.0)
//        animation.toValue = ((-30.0 * CGFloat(M_PI)) / 180.0)
//        animation.toValue = ((0.0 * CGFloat(M_PI)) / 180.0)
//        image.layer.addAnimation(animation, forKey: "transform.rotation")
//    }
    
    
    /* UNWIND SEGUE */
    @IBAction func restart (segue:UIStoryboardSegue) {
        print("Restarting")
    }
}

