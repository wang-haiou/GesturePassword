//
//  UGesturesLogin.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/21.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

class UGesturesLogin: NSObject {

    let window = UIWindow(frame: UIScreen.main.bounds)
    
    static let `default`: UGesturesLogin = UGesturesLogin()
    
    private override init() {
        window.rootViewController = UIViewController()
    }
    func showGesture(_ animated: Bool, completion: ((String)->Void)? = nil) {
        
        guard Defaults[.gesturePreference] else {
            completion?("应用未开启偏好设置")
            return
        }
        
        if window.isHidden {
            show()
            let ges = UGestureCodeViewController(type: .login, gestureResults: { (result) in
                completion?(result)
            })
            window.rootViewController?.present(ges, animated: animated, completion: nil)
        }
    }
    private func show() {
        window.isHidden = false
        window.makeKey()
        window.windowLevel = UIWindowLevelStatusBar
    }
    func hide() {
        window.resignKey()
        window.windowLevel = UIWindowLevelNormal
        window.isHidden = true
    }
    
}
