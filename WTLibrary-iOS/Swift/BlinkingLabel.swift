//
//  BlinkingLabel.swift
//  Pods
//
//  Created by iMac on 12/16/15.
//
//

import Foundation

public class BlinkingLabel : UILabel {
    public func startBlinking() {
        let options : UIViewAnimationOptions = [.repeat, .curveEaseInOut]
        UIView.animate(withDuration: 0.25, delay:0.0, options:options, animations: {
            self.alpha = 0
            }, completion: nil)
    }
    
    public func stopBlinking() {
        alpha = 1
        layer.removeAllAnimations()
    }
}
