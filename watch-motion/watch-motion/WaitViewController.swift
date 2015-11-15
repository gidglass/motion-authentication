//
//  WaitViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit
import WatchConnectivity

class WaitViewController: UIViewController, WCSessionDelegate {
    @IBOutlet weak var watchImage: UIImageView!

    var session: WCSession!
    var phoneData: MotionData! // model passed from previous controller
    var watchData: MotionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (WCSession.isSupported()) {
            print("WCSession is supported 2")
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
//        self.sendMessage(["status": "waiting"])
        
        
        // Animate
        shake(watchImage)
        
        print("PHONE X:") // TESTING PURPOSES!
        print(phoneData.x) // TESTING PURPOSES!
        
        print("WATCH X:") // TESTING PURPOSES!
        print(watchData.x) // TESTING PURPOSES!
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMessage (message: AnyObject) {
        session.sendMessage(message as! [String : AnyObject],
            replyHandler: { replyMessage in
                print(replyMessage)
            },
            errorHandler: {error in
                print(error)
        })
    }
//    
//    func session (session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        //handle received message
//        let status = message["status"] as! String
//        print("STATUS: \(status)")
//        
//        if status == "recorded" {
//            dispatch_async(dispatch_get_main_queue()) {
//                self.performSegueWithIdentifier("authenticate", sender: self)
//                print("AUTHENTICATING")
//            }
//
//        }
//        //
//        //
//        //        replyHandler(["Value":"Hello Watch"])
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
