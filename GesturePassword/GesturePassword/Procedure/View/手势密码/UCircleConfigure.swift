//
//  UCircleConfigure.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/17.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

/// 单个圆背景色 
public var circleBackgroundColor: UIColor = .clear

///普通状态下外空心圆颜色
public var circleStateNormalOutsideColor: UIColor = UIColor.hex("CCCCCC")

///选中状态下外空心圆颜色
public var circleStateSelectedOutsideColor: UIColor = UIColor.hex("D3361C")

///错误状态下外空心圆颜色
public var circleStateErrorOutsideColor: UIColor = UIColor.hex("F5A623")

///普通状态下内实心圆颜色
public var circleStateNormalInsideColor: UIColor = UIColor.hex("CCCCCC")

///选中状态下内实心圆颜色
public var circleStateSelectedInsideColor: UIColor = UIColor.hex("D3361C")

///错误状态内实心圆颜色
public var circleStateErrorInsideColor: UIColor = UIColor.hex("F5A623")

///普通状态下三角形颜色
public var circleStateNormalTrangleColor: UIColor = .clear

///选中状态下三角形颜色
public var circleStateSelectedTrangleColor: UIColor = UIColor.hex("D3361C")

///错误状态三角形颜色
public var circleStateErrorTrangleColor: UIColor = UIColor.hex("F5A623")

///普通时连线颜色
public var circleConnectLineNormalColor: UIColor = UIColor.hex("D3361C")

///错误时连线颜色
public var circleConnectLineErrorColor: UIColor = UIColor.hex("F5A623")

///普通状态下文字提示的颜色
public var textColorNormalState: UIColor = UIColor.hex("666666")

///警告状态下文字提示的颜色
public var textColorWarningState: UIColor = UIColor.hex("666666")

//三角形边长
public var kTrangleLength: CGFloat = 10.0

//连线宽度
public var circleConnectLineWidth: CGFloat = 1.0

//单个圆的半径
public var circleRadius: CGFloat = ScaleW(65)

//单个圆的圆心
public var circleCenter: CGPoint = CGPoint(x: circleRadius, y: circleRadius)

//空心圆圆环宽度
public var circleEdgeWidth: CGFloat = ScaleW(3)

//九宫格展示infoView 单个圆的半径
public var circleInfoRadius: CGFloat = ScaleW(32)

//内部实心圆占空心圆的比例系数
public var circleRadio: CGFloat = 0.29

//整个解锁View居中时，距离屏幕左边和右边的距离
public var circleViewEdgeMargin: CGFloat = ScaleW(74)

//连接的圆最少的个数
public var circleSetCountLeast: Int = 4

//错误状态下回显的时间
public var displayTime: TimeInterval = 1.0

//回显图片Documents
public var gestureDefaultImagePath: String = NSHomeDirectory().appending("/Documents/").appending("gestureDefaultImage.png")

/// 绘制解锁界面准备好时，提示文字
public var gestureTextBeforeSet = "为了您的账户安全，请设置手势密码"

///从新设置新密码时的提示语
public var gestureTextBeforeNewSet = "请设置新手势密码"

///登录验证时的提示语
public var gestureTextLogin = "请绘制手势密码进行解锁"

///设置时，连线个数少，提示文字
public var gestureTextConnectLess = "最少连接\(circleSetCountLeast)个点，请重新输入"

///确认图案，提示再次绘制
public var gestureTextDrawAgain = "请再次绘制手势密码"

///再次绘制不一致，提示文字
public var gestureTextDrawAgainError = "两次手势密码不一致，请重新绘制"

///设置成功
public var gestureTextSetSuccess = "设置成功"

///请输入原手势密码
public var gestureTextOldGesture = "请绘制原手势密码"

///允许用户手势错误验证次数
public var errorCountLeast: Int = 5

