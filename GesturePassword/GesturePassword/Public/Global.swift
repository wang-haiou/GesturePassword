//
//  Global.swift
//  GesturePassword
//
//  Created by Seagull on 2017/10/24.
//  Copyright © 2017年 Seagull. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

//MARK: 快捷开发
typealias DicValue = [String:Any]
typealias StringClosures = (String)->Void
typealias CompletionClosure = ()->Void
//MARK: 尺寸
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
func ScaleW(_ width:CGFloat) -> CGFloat {
    return width*screenW/750.0
}
func ScaleH(_ height:CGFloat) -> CGFloat {
    return height*screenH/1334.0
}

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

//MARK: print
func uLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

