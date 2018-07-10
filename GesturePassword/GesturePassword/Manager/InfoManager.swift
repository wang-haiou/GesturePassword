//
//  InfoManager.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/3.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

let Defaults = SwiftyUserDefaults.Defaults

// MARK: - 手势密码
extension DefaultsKeys {
    
    static let gesturePasswordSetingOne = DefaultsKey<String?>("gesturePasswordSetingOne")//第一个手势密码存储key
    static let gesturePassword = DefaultsKey<String?>("gesturePassword")//最终的手势密码存储key
    static let gesturePreference = DefaultsKey<Bool>("gesturePreference")//用户是否开启手势解锁
    
}

