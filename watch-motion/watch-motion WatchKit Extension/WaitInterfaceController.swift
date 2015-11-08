//
//  WaitInterfaceController.swift
//  watch-motion WatchKit Extension
//
//  Created by Gideon I. Glass on 11/1/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation



class WaitInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        if (WCSession.isSupported()) {
            print("WCSession is supported")
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Wait for iPhone to initiate
    
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
            dispatch_async(dispatch_get_main_queue()) {
                self.pushControllerWithName("recordMotion", context: status)
            }
        }
//        
//        
//        replyHandler(["Value":"Hello Watch"])
    }


}
