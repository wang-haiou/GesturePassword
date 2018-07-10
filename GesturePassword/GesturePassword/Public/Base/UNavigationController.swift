//
//  UNavigationController.swift
//  GesturePassword
//
//  Created by Seagull on 2017/9/29.
//  Copyright © 2017年 Seagull. All rights reserved.
//

import UIKit

class UNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationBar.setBackgroundImage(UIImage(named: "BackgroundNav"), for: UIBarMetrics.default)
        let dict:NSDictionary = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor: UIColor.hex("FFFFFF")]
        //标题设置颜色与字体大小
        self.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : Any]
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
}

extension UNavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = topViewController else { return .lightContent }
        return topVC.preferredStatusBarStyle
    }
}
