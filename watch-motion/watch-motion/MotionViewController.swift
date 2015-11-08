//
//  MotionViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var isRecording: UIActivityIndicatorView!
    @IBOutlet weak var phoneImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redoButton.enabled = false
        redoButton.alpha = 0.3
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(phoneImage.center.x - 10, phoneImage.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(phoneImage.center.x + 10, phoneImage.center.y))
        phoneImage.layer.addAnimation(animation, forKey: "position")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMotion(sender: UIBarButtonItem) {
        performSegueWithIdentifier("saveMotion", sender: self)
    }

    @IBAction func redo(sender: UIButton) {
        
    }
    
    @IBAction func record(sender: UIButton) {
        isRecording.startAnimating()
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
