//
//  MotionInterfaceController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/3/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class MotionInterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var recordButton: WKInterfaceButton!
    @IBOutlet var redoButton: WKInterfaceButton!
    @IBOutlet var saveButton: WKInterfaceButton!
    
    var session: WCSession!
    var recordedData:MotionData!
    lazy var motionManager = CMMotionManager()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            print("WCSession is supported")
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        self.redoButton.setEnabled(false)
        self.saveButton.setEnabled(false)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func saveMotion() {
        sendMessage(["status": "recorded"])
        pushControllerWithName("authenticate", context:recordedData)
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
    
    func session (session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        let status = message["status"] as! String
        print("STATUS: \(status)")
        
        if status == "waiting" {
//            pushControllerWithName("recordMotion", context: status)
        }
        
//        replyHandler([String:AnyObject]) {
//            
//        }
    }
    
    
    /* HANDLE ACCELEROMETER DATA */
    @IBAction func record() {
        if motionManager.accelerometerAvailable{
            // Disable until redo button pressed
            recordButton.setEnabled(false)
            redoButton.setEnabled(true)
            saveButton.setEnabled(true)
            
            // Collect sensor data
            collectData()
        } else {
            print("NO SENSOR AVAILABLE")
        }
    }
    
    @IBAction func redo() {
        saveButton.setEnabled(false)
        redoButton.setEnabled(false)
        recordButton.setEnabled(true)
    }
    
    
    func collectData () {
        if motionManager.accelerometerAvailable{
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
                    return
                }
            })
        }
    }
}
