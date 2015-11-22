//
//  ResultViewController.swift
//  watch-motion
//
//  Created by Gideon I. Glass on 11/6/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var authenticating: UIActivityIndicatorView!
    @IBOutlet weak var restartButton: UIButton!
    
    var phoneData: MotionData!
    var watchData: MotionData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare view
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.authenticating.startAnimating()
        self.statusImage.hidden = true
        self.restartButton.enabled = false
        self.restartButton.alpha = 0.3
        
        // Convert MotionData to JSON format
        let data = ["phone": phoneData.toDictionary(), "watch": watchData.toDictionary()]
        
        // Make HTTP request
        let http = HTTP()
        let requestJSON = http.toJSON(data)
        http.POST("https://young-meadow-1985.herokuapp.com/checkSync/", requestJSON: requestJSON!, postComplete: {(success: Bool, msg: String) in
            dispatch_async(dispatch_get_main_queue()) {
                if success {
                    self.authenticating.stopAnimating()
                    self.statusLabel.text = "Match!"
                    self.statusImage.image = UIImage(named: "check")
                    self.grow(self.statusImage)
                    UIView.animateWithDuration(0.3, animations: {
                        self.restartButton.enabled = true
                        self.restartButton.alpha = 1.0
                    })
                } else {
                    self.authenticating.stopAnimating()
                    self.statusLabel.text = "Doesn't Match!"
                    self.statusImage.image = UIImage(named: "fail")
                    self.grow(self.statusImage)
                    UIView.animateWithDuration(0.3, animations: {
                        self.restartButton.enabled = true
                        self.restartButton.alpha = 1.0
                    })
                }
            }
        })
        
        // TODO: Also send message to watch to update UI
        
        // Print to console for debugging
//        print("JSON DATA:")
//        print(NSString(data: requestJSON!, encoding: NSUTF8StringEncoding) as! String, "\n")
        
    }
    
    /* ANIMATION */
    
    func grow (image: UIImageView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.fromValue = NSNumber(double: 0.0)
        animation.toValue = NSNumber(double: 1.0)
        image.layer.addAnimation(animation, forKey: "transform.scale")
        image.hidden = false
    }

}
