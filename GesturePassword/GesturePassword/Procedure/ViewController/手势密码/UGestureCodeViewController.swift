//
//  UGestureCodeViewController.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/18.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

// MARK: -  手势密码界面用途类型
enum GesturesType: String {
    case setting = "设置"
    case update  = "更新"
    case verify  = "验证"
    case login   = "登陆"
    
    // MARK: - 获取当前状态信息
    func displayContent() -> (title:String,alert:String) {
        switch self {
        case .setting:
            return ("设置手势密码",gestureTextBeforeSet)
        case .update:
            return ("修改手势密码",gestureTextOldGesture)
        case .verify:
            return ("关闭手势密码",gestureTextOldGesture)
        case .login:
            return ("",gestureTextLogin)
        }
    }
}

class UGestureCodeViewController: UBaseViewController {
    
    var gesturesType: GesturesType
    var gestureResultsClosures: StringClosures
    
    init(type: GesturesType, gestureResults: @escaping StringClosures) {
        gesturesType = type
        gestureResultsClosures = gestureResults
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.gesturePasswordSetingOne] = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.hex("F2F2F2")
    }
    override func configUI() {
        
        let display = gesturesType.displayContent()
        self.title = display.title
        
        msgLabel.showNormal(display.alert)
        view.addSubview(msgLabel)
        msgLabel.snp.makeConstraints({
            $0.left.right.equalTo(0)
            $0.top.equalTo(view.usnp.top).offset(ScaleH(156))
            $0.height.equalTo(13)
        })
        
        view.addSubview(lockView)
        lockView.snp.makeConstraints({ (m) in
            m.top.equalTo(msgLabel.snp.bottom).offset(25)
            m.centerX.equalTo(view)
            let sizeWH = screenW-circleViewEdgeMargin*2
            m.size.equalTo(CGSize(width: sizeWH, height: sizeWH))
        })
        
        //let image = UIImage(contentsOfFile: gestureDefaultImagePath)
        
        if gesturesType == .update {
            view.addSubview(forgetPasswordBtn)
            forgetPasswordBtn.snp.makeConstraints({
                $0.centerX.equalTo(view)
                $0.bottom.equalTo(view.usnp.bottom).offset(-65)
                $0.size.equalTo(CGSize(width: 75, height: 24))
            })
        }else if gesturesType == .login {
            view.addSubview(forgetPasswordBtn)
            forgetPasswordBtn.snp.makeConstraints({
                $0.centerX.equalTo(view)
                $0.bottom.equalTo(view.usnp.bottom).offset(-65)
                $0.size.equalTo(CGSize(width: 75, height: 24))
            })
            view.addSubview(welcomeLab)
            welcomeLab.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.usnp.top).offset(ScaleH(134))
                $0.height.equalTo(30)
            })
            msgLabel.snp.updateConstraints({ (m) in
                m.top.equalTo(view.usnp.top).offset(ScaleH(248))
            })
        }
    }
    
    // MARK: 忘记密码Click
    @objc func forgetPasswordClick(sender:UIButton) {
        self.alert(title: "提示", message: "忘记密码需要重新登录", confirm: "重新登录", cancel: "取消") {
            self.gestureResultsClosures("忘记手势密码")
            Defaults[.gesturePreference] = false
            Defaults[.gesturePassword] = nil
        }
    }
    override func pressBack() {
        if (navigationController != nil) {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: {
                UGesturesLogin.default.hide()
            })
        }
    }
    // MARK: - 懒加载
    private lazy var lockView: UCircleView = {
        let lv = UCircleView(type: gesturesType)
        lv.delegate = self
        return lv
    }()
    
    private lazy var msgLabel: UWarnLabel = {
        let lab = UWarnLabel()
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textColor = textColorWarningState
        return lab
    }()
    
    private lazy var welcomeLab: UILabel = {
        //UGradientLabel(colors: [UIColor.hex(0xF9B920),UIColor.hex(0xE09015)])
        let lab = UILabel()
        lab.text = "欢迎回来"
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 32)
        lab.textColor = UIColor.hex("D3361C")
        lab.sizeToFit()
        return lab
    }()
    
    private lazy var forgetPasswordBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记手势密码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.hex("D3361C"), for: .normal)
        btn.addTarget(self, action: #selector(forgetPasswordClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
// MARK: - 设置手势密码代理方法
extension UGestureCodeViewController:CircleViewDelegate {
    /**
     *  连线个数少于4个时，通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 手势结果
     */
    func connectCirclesLessThanNeed(view: UCircleView, type: GesturesType, gesture: String) {
        if Defaults[.gesturePasswordSetingOne] != nil {
            msgLabel.showWarn(gestureTextDrawAgainError)
        }else {
            msgLabel.showWarn(gestureTextConnectLess)
        }
    }
    /**
     *  连线个数多于或等于4个，获取到第一个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第一个次保存的密码
     */
    func didCompleteSetFirstGesture(view: UCircleView, type: GesturesType, gesture: String) {
        msgLabel.showNormal(gestureTextDrawAgain)
    }
    /**
     *  获取到第二个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第二次手势密码
     *  @param equal   第二次和第一次获得的手势密码匹配结果
     */
    func didCompleteSetSecondGesture(view: UCircleView, type: GesturesType, gesture: String, result equal: Bool) {
        if equal { //两次密码相等
            // 存储手势密码
            Defaults[.gesturePassword] = gesture
            //设置用户开启手势密码偏好设置
            Defaults[.gesturePreference] = true
            //提示成功保存密码
            msgLabel.showNormal(gestureTextSetSuccess)
            //延时返回
            DispatchQueue.default.delay(0.4) {
                self.pressBack()
            }
            if gesturesType == .update {
                gestureResultsClosures("手势更新成功")
            }else {
                gestureResultsClosures("手势设置成功")
            }
        }else {
            //两次密码不等
            Defaults[.gesturePasswordSetingOne] = nil
            msgLabel.showWarn(gestureTextDrawAgainError)
        }
    }
    /**
     *  登陆或者验证手势密码输入完成时的代理方法
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 登陆时的手势密码
     */
    func didCompleteLoginGesture(view: UCircleView, type: GesturesType, gesture: String, result equal: Bool) {
        // 此时的type有两种情况 Login or verify
        if equal {
            if type == .login || type == .verify {
                pressBack()
                if type == .verify {
                    Defaults[.gesturePreference] = false
                }
                gestureResultsClosures("手势验证成功")
            }else {
                //更新手势密码
                lockView.gesturesType = .setting
                msgLabel.showNormal(gestureTextBeforeNewSet)
            }
        }else {
            //设置允许用户手势错误验证次数
            errorCountLeast -= 1
            if errorCountLeast > 0 {
                msgLabel.showWarn("密码错误，还可以再输入\(errorCountLeast)次")
            }else {
                //最后一次输入密码错误
                gestureResultsClosures("手势验证失败")
                //关闭手势密码偏好设置
                Defaults[.gesturePreference] = false
                //清除手势密码
                Defaults[.gesturePassword] = nil
                
                
                
                self.alert(title: "提示", message: "密码输错5次，将重新登录进行验证", confirm: "确定", cancel: nil, handle: {
                    
                })
            }
        }
    }
    /**
     自己添加,用于返回绘制结束时的image
     
     @param view  circleView
     @param type  type
     @param image 绘制结束时的图案
     */
    func didEndGesture(view: UCircleView, type: GesturesType, image: UIImage) {
//        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: screenW, height: 200))
//        imageV.image = image
//        view.addSubview(imageV)
    }
}
