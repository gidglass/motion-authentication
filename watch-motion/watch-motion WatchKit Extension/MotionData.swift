//
//  MotionData.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/5/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import Foundation

class MotionData {
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
}
