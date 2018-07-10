//
//  CALayerExtensions.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/19.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

extension CALayer {
    
    func shake() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let s = 5
        keyFrameAnimation.values = [0, -s, 0, s, 0, -s, 0, s, 0]
        keyFrameAnimation.duration = 0.3
        keyFrameAnimation.repeatCount = 2
        keyFrameAnimation.isRemovedOnCompletion = true
        add(keyFrameAnimation, forKey: "shake")
    }
    
}

