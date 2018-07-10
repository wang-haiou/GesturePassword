//
//  UIViewControllerExtension.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/22.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

enum KTransitionType {
    /**
     *  淡入淡出
     */
    case fade
    /**
     *  推挤
     */
    case push
    /**
     *  揭开
     */
    case reveal
    /**
     *  覆盖
     */
    case moveIn
    /**
     *  立方体
     */
    case cube
    /**
     *  吮吸
     */
    case suckEffect
    /**
     *  翻转
     */
    case oglFlip
    /**
     *  波纹
     */
    case rippleEffect
    /**
     *  翻页
     */
    case pageCurl
    /**
     *  反翻页
     */
    case pageUnCurl
    /**
     *  开镜头
     */
    case cameraIrisHollowOpen
    /**
     *  关镜头
     */
    case cameraIrisHollowClose
    
    func transitionType() -> String {
        switch self {
            /**
             *  淡入淡出
             */
        case .fade: return kCATransitionFade
            /**
             *  推挤
             */
        case .push: return kCATransitionPush
            /**
             *  揭开
             */
        case .reveal: return kCATransitionReveal
            /**
             *  覆盖
             */
        case .moveIn: return kCATransitionMoveIn
            /**
             *  立方体
             */
        case .cube: return "cube"
            /**
             *  吮吸
             */
        case .suckEffect: return "suckEffect"
            /**
             *  翻转
             */
        case .oglFlip: return "oglFlip"
            /**
             *  波纹
             */
        case .rippleEffect: return "rippleEffect"
            /**
             *  翻页
             */
        case .pageCurl: return "pageCurl"
            /**
             *  反翻页
             */
        case .pageUnCurl: return "pageUnCurl"
            /**
             *  开镜头
             */
        case .cameraIrisHollowOpen: return "cameraIrisHollowOpen"
            /**
             *  关镜头
             */
        case .cameraIrisHollowClose: return "cameraIrisHollowClose"

        }
    }
}

enum KTransitionDirection{
    case bottom
    case left
    case right
    case top
    
    func direction() -> String {
        switch self {
        case .bottom: return kCATransitionFromBottom
            
        case .left: return kCATransitionFromLeft
            
        case .right: return kCATransitionFromRight
        
        case .top: return kCATransitionFromTop
        }
    }
}

// MARK: - 过渡动画
extension UIViewController {
    func present(_ viewController: UIViewController, type: KTransitionType, direction: KTransitionDirection, completion: (()->Void)? = nil) {
        view.window?.animation(type: type, direction: direction)
        present(viewController, animated: false, completion: completion)
    }
    func dismiss(type: KTransitionType, direction: KTransitionDirection, completion: (()->Void)? = nil) {
        view.window?.animation(type: type, direction: direction)
        dismiss(animated: false, completion: completion)
    }
}
// MARK: - 体统提示
extension UIViewController {
    func alert(title: String?, message: String?, confirm: String, cancel: String?, handle: (()-> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirm, style: .default) { (action) in
            handle?()
        }
        alertController.addAction(confirmAction)
        if cancel != nil {
            let cancelAction = UIAlertAction(title: cancel, style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

