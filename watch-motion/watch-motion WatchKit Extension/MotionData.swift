//
//  MotionData.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/5/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import Foundation
import CoreMotion

class MotionData {
    lazy var motionManager = CMMotionManager()
    
    var x:[Double]
    var y:[Double]
    var z:[Double]
    
    init () {
        self.x = [Double]()
        self.y = [Double]()
        self.z = [Double]()
    }
    
    init (x:[Double], y:[Double], z:[Double]) {
        self.x = x
        self.y = y
        self.z = z
    } // constructor
    
    init (copyData: MotionData) {
        self.x = copyData.x
        self.y = copyData.y
        self.z = copyData.z
    } // copy constructor
    
    func copy () -> MotionData {
        return MotionData(copyData: self)
    }
    
    private func toDictionary () -> NSDictionary {
        let dict:[String:[Double]] = [
            "x": self.x,
            "y": self.y,
            "z": self.z
        ]
        
        return dict
    }
    
    func toJSON () -> NSData? {
        let dict = self.toDictionary()
        
        if NSJSONSerialization.isValidJSONObject(dict) {
            do {
                let json = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions())
                return json
            } catch let error as NSError {
                print("ERROR: Unable to serialize json, error: \(error)")
            }
        }
        return nil
    }
    
    func clearData () {
        self.x.removeAll()
        self.y.removeAll()
        self.z.removeAll()
    }
    
    func collectData (SAMPLE_SIZE:Int = 100, callback: () -> ()) {
        if motionManager.accelerometerAvailable {
            self.clearData()
            var sampleSize:Int = 0
            let queue = NSOperationQueue.mainQueue()
        
            print("X\tY\tZ")
            
            self.motionManager.startAccelerometerUpdatesToQueue(queue, withHandler: {data, error in
                guard let data = data else {
                    return
                }
                
                if sampleSize++ < SAMPLE_SIZE {
                    self.x.append(data.acceleration.x)
                    self.y.append(data.acceleration.y)
                    self.z.append(data.acceleration.z)
                    
                    print(data.acceleration.x, "\t", data.acceleration.y, "\t", data.acceleration.z)
                } else {
                    self.motionManager.stopAccelerometerUpdates()
                    print("Collected \(SAMPLE_SIZE) Samples")
                    print("X COUNT: ", self.x.count)
                    print("Y COUNT: ", self.y.count)
                    print("Z COUNT: ", self.z.count)

                    // Signal callback in main thread
                    callback()
                    return
                }
            })
        } else {
            print("NO SENSOR AVAILABLE")
        }
    }
}