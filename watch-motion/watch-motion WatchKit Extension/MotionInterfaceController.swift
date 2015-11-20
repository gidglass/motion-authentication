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
    @IBOutlet var statusLabel: WKInterfaceLabel!
    var recordedData = MotionData()
    var session: WCSession!
    var currentState = UserState.Waiting
    let SAMPLE_SIZE = 200
    
    // Still tweaking - trying to make sure watch in sync with iPhone...
    enum UserState {
        case Waiting, Recording, Authenticating
    }

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
        
        switch currentState {
            case .Recording:
                self.statusLabel.setText("Recording Motion!")
                break
            case .Authenticating:
                self.statusLabel.setText("Waiting to authenticate...")
                break
            default:
                self.statusLabel.setText("Follow instructions on your iPhone.")
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
            dispatch_async(dispatch_get_main_queue()) {
                self.currentState = .Recording
                self.statusLabel.setText("Recording motion!")
            }
            self.recordedData.collectData(SAMPLE_SIZE, callback: {
                
                let watchData = [
                    "x": self.recordedData.x,
                    "y": self.recordedData.y,
                    "z": self.recordedData.z
                ]
                
                replyHandler(watchData)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.currentState = .Authenticating
                    self.statusLabel.setText("Waiting to authenticate...")
                }
            })
        }
    }

    func finishedRecording () {
        print("Finished watch recording")
    }
}
