//
//  ViewController.swift
//  GesturePassword
//
//  Created by Seagull on 2017/12/27.
//  Copyright © 2017年 Seagull. All rights reserved.
//

import UIKit

class ViewController: UBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func setingClick() {
        //设置(更新、验证)手势密码
        navigationController?.pushViewController(UGestureCodeViewController(type: .setting, gestureResults: { (result) in
            uLog(result)
        }), animated: true)
    }
    @IBAction func updateClick() {
        //更新手势密码
        navigationController?.pushViewController(UGestureCodeViewController(type: .update, gestureResults: { (result) in
            uLog(result)
        }), animated: true)
    }
    @IBAction func loginClick() {
        //手势密码的登录
        Defaults[.gesturePreference] = true //开启手势密码的偏好设置
        UGesturesLogin.default.showGesture(true) { (str) in
            uLog(str)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
