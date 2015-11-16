//
//  MotionViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit
import WatchConnectivity

class MotionViewController: UIViewController, WCSessionDelegate {

    let SAMPLE_SIZE = 100 // number of samples to record

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var isRecording: UIActivityIndicatorView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var watchImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var phoneData = MotionData()
    var watchData = MotionData()
    var session: WCSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check is Apple Watch is reachable
        if (WCSession.isSupported()) {
            print("WCSession is supported.")
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }

        // Initialize button states
        saveButton.enabled = false
        redoButton.enabled = false
        redoButton.alpha = 0.3
        checkImage.hidden = true
        
        // Shake phone image
        shake(phoneImage)
        shake(watchImage)
    }
    
    // Shake animation
    func shake (image: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(image.center.x - 10, image.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(image.center.x + 10, image.center.y))
        image.layer.addAnimation(animation, forKey: "position")
    }
    
    func grow (image: UIImageView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.fromValue = NSNumber(double: 0.0)
        animation.toValue = NSNumber(double: 1.0)
        image.layer.addAnimation(animation, forKey: "transform.scale")
        image.hidden = false
    }
    
    func toggleFade (image: UIImageView) {
        UIView.animateWithDuration(0.3, animations: {
            if image.alpha == 0.0 {
                image.alpha = 1.0
            } else {
                image.alpha = 0.0
            }
        })
    }

    
    /* BUTTON ACTIONS */
    
    @IBAction func saveMotion(sender: UIBarButtonItem) {
        performSegueWithIdentifier("saveMotion", sender: self)
    }

    @IBAction func redo(sender: UIButton) {
        // Clear recorded data
        phoneData.clearData()
        watchData.clearData()
        
        // Change button states
        UIView.animateWithDuration(0.3, animations: {
            self.checkImage.hidden = true
            self.saveButton.enabled = false
            self.redoButton.enabled = false
            self.redoButton.alpha = 0.3
            self.recordButton.enabled = true
            self.recordButton.alpha = 1.0
        })
    }
    
    @IBAction func record(sender: UIButton) {
        self.isRecording.startAnimating()
        
        // Change button states
        UIView.animateWithDuration(0.3, animations: {
            self.recordButton.enabled = false
            self.recordButton.alpha = 0.3
        })
        
        // Signal Apple Watch to record data
        self.sendMessage(["status":"recording"])
        
        // Start collecting data on iPhone
        phoneData.collectData(SAMPLE_SIZE, callback: {
            self.toggleButtonStates()
            self.grow(self.checkImage)
        })

    }
    
    func toggleButtonStates () {
        // Change button states when finished recording
        self.isRecording.stopAnimating()
        UIView.animateWithDuration(0.3, animations: {
            self.redoButton.enabled = true
            self.redoButton.alpha = 1.0
            self.saveButton.enabled = true
        })
    }
    
    /* WATCH CONNECTIVITY */
    
    func sendMessage (message: AnyObject) {
        session.sendMessage(message as! [String : AnyObject],
            replyHandler: { replyMessage in
                // Grab values
                let x = replyMessage["x"] as! [Double]
                let y = replyMessage["y"] as! [Double]
                let z = replyMessage["z"] as! [Double]
                
                // Create new object
                self.watchData = MotionData(x: x, y: y, z: z)
            },
            errorHandler: {error in
                print(error)
        })
    }
    
    /* NAVIGATION */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Update model and pass data to next controller
        let resultVC = segue.destinationViewController as! ResultViewController
        resultVC.phoneData = self.phoneData.copy()
        resultVC.watchData = self.watchData.copy()
    }
}
