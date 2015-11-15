//
//  MotionViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit
import WatchConnectivity

class MotionViewController: UIViewController {

    let SAMPLE_SIZE = 100 // number of samples to record

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var isRecording: UIActivityIndicatorView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
//    @IBOutlet weak var recordingProgress: UIProgressView!
    
    var session: WCSession!
    var recordedData = MotionData() // model

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize button states
        saveButton.enabled = false
        redoButton.enabled = false
        redoButton.alpha = 0.3
        
        // Shake phone image
        shake(phoneImage)
    }
    
    // Shake animation
    private func shake (image: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(image.center.x - 10, image.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(image.center.x + 10, image.center.y))
        image.layer.addAnimation(animation, forKey: "position")
    }
    
    /* BUTTON ACTIONS */
    
    @IBAction func saveMotion(sender: UIBarButtonItem) {
        performSegueWithIdentifier("saveMotion", sender: self)
    }

    @IBAction func redo(sender: UIButton) {
        // Clear recorded data
        recordedData.clearData()
        
        // Change button states
        UIView.animateWithDuration(0.3, animations: {
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
        
        // Collect sensor data
        recordedData.collectData(SAMPLE_SIZE, handler:toggleButtonStates)
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
    
    /* NAVIGATION */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Update model and pass data to next controller
        let waitVC = segue.destinationViewController as! WaitViewController
        waitVC.recordedData = self.recordedData.copy()
    }
}
