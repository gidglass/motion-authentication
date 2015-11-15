//
//  MotionInterfaceController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/14/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MotionInterfaceController: WKInterfaceController, WCSessionDelegate {
    var recordedData = MotionData()
    var session: WCSession!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /* WATCH CONNECTIVITY */
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        let status = message["status"] as? String
        
        if status == "recording" {
            print ("WATCH RECORDING")
            self.recordedData.collectData(callback: {
                
                let watchData = [
                    "x": self.recordedData.x,
                    "y": self.recordedData.y,
                    "z": self.recordedData.z
                ]
                
                replyHandler(watchData)
            })
        }
        
//        //Use this to update the UI instantaneously (otherwise, takes a little while)
//        dispatch_async(dispatch_get_main_queue()) {
//            self.counterData.append(counterValue!)
//            self.mainTableView.reloadData()
//        }
    }

    func finishedRecording () {
        print("Finished watch recording")
    }
}
