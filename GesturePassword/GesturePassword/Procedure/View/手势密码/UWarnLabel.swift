//
//  UWarnLabel.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/19.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

class UWarnLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        backgroundColor = UIColor.clear
    }
    
    func showNormal(_ message: String) {
        text = message
    }
    
    func showWarn(_ message: String) {
        text = message
        textColor = textColorWarningState
        layer.shake()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
