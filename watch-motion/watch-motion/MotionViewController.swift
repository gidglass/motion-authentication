//
//  MotionViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit
import CoreMotion

class MotionViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var isRecording: UIActivityIndicatorView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var motionManager = CMMotionManager()
    var recordedData: MotionData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.enabled = false
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
        UIView.animateWithDuration(0.3, animations: {
            self.saveButton.enabled = false
            self.redoButton.enabled = false
            self.redoButton.alpha = 0.3
            self.recordButton.enabled = true
            self.recordButton.alpha = 1.0
        })
    }
    
    @IBAction func record(sender: UIButton) {
        if motionManager.accelerometerAvailable{
            // Disable until redo button pressed
            self.isRecording.startAnimating()

            UIView.animateWithDuration(0.3, animations: {
                self.recordButton.enabled = false
                self.recordButton.alpha = 0.3
            })
            
            // Collect sensor data
            collectData()
        } else {
            print("NO SENSOR AVAILABLE")
        }

    }
    
    func collectData () {
        // Variables
        var sampleSize:Int = 0
        var x:[Double] = [Double]()
        var y:[Double] = [Double]()
        var z:[Double] = [Double]()
        
        let queue = NSOperationQueue.mainQueue()

        print("X\tY\tZ")
        
        motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {data, error in
            guard let data = data else{
                return
            }
            
            if sampleSize++ < 100 {
                x.append(data.acceleration.x)
                y.append(data.acceleration.y)
                z.append(data.acceleration.z)
                
                print(data.acceleration.x, "\t", data.acceleration.y, "\t", data.acceleration.z)
            } else {
                self.recordedData = MotionData(x: x, y: y, z: z)
                self.motionManager.stopAccelerometerUpdates()
                print("Collected 100 Samples")
                print("X COUNT: ", x.count)
                print("Y COUNT: ", y.count)
                print("Z COUNT: ", z.count)
                
                // Change buttons
                self.isRecording.stopAnimating()
                UIView.animateWithDuration(0.3, animations: {
                    self.redoButton.enabled = true
                    self.redoButton.alpha = 1.0
                    self.saveButton.enabled = true
                })

                return
            }
        })
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
