//
//  swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/17.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

// MARK: - 设置手势密码代理方法
protocol CircleViewDelegate: class {
    /**
     *  连线个数少于4个时，通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 手势结果
     */
    func connectCirclesLessThanNeed(view:UCircleView, type: GesturesType, gesture:String)
    /**
     *  获取到第一个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第一个次保存的密码
     */
    func didCompleteSetFirstGesture(view:UCircleView, type: GesturesType, gesture:String)
    /**
     *  获取到第二个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第二次手势密码
     *  @param equal   第二次和第一次获得的手势密码匹配结果
     */
    func didCompleteSetSecondGesture(view:UCircleView, type: GesturesType, gesture:String, result equal:Bool)
    /**
     *  登陆或者验证手势密码输入完成时的代理方法
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 登陆时的手势密码
     */
    func didCompleteLoginGesture(view:UCircleView, type: GesturesType, gesture:String, result equal:Bool)
    /**
     自己添加,用于返回绘制结束时的image
     
     @param view  circleView
     @param type  type
     @param image 绘制结束时的图案
     */
    func didEndGesture(view:UCircleView, type: GesturesType, image:UIImage)
}
class UCircleView: UIView {

    var gesturesType: GesturesType
    var clip = true //是否剪裁圈内的连接线
    
    //是否有箭头
    var arrow = true {
        didSet{
            for (_ , circle) in subviews.enumerated() {
                if let circle = circle as? UCircle {
                    circle.arrow = oldValue
                }
            }
        }
    }
        
    private var isTouchBegin = false //监控是否是开始触摸的状态
    private lazy var circleSet = [UCircle]() //选中的圆的集合
    private var currentPoint: CGPoint = .zero // 当前点
    private var hasClean = false // 数组清空标志
    weak var delegate: CircleViewDelegate?
    var lock = NSLock()
    
    init(type: GesturesType) {
        self.gesturesType = type
        super.init(frame: .zero)
        lockViewPrepare()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 解锁视图准备
    func lockViewPrepare() {
        backgroundColor = circleBackgroundColor
        
        for _ in 0..<9 {
            let circle = UCircle()
            circle.arrow = arrow
            addSubview(circle)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemViewWH :CGFloat = circleRadius * 2
        let marginValue :CGFloat = (self.frame.size.width - 3 * itemViewWH) / 3.0
        for (idx , subview) in subviews.enumerated() {
            let row: CGFloat = CGFloat(idx % 3)
            let col: CGFloat = CGFloat(idx / 3)
            let x :CGFloat = marginValue * row + row * itemViewWH + marginValue/2
            let y :CGFloat = marginValue * col + col * itemViewWH + marginValue/2
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            subview.tag = idx + 1
            subview.frame = frame
        }
        // 自己添加保存解锁图案默认图
        saveDefaultImage()
    }
    // MARK: - 自己添加保存解锁图案默认图
    func saveDefaultImage() {
        var img = UIImage(contentsOfFile: gestureDefaultImagePath)
        if img == nil {
            img = shotView()
            guard let data = UIImagePNGRepresentation(img!) else {
                return
            }
            do {
                try data.write(to: URL(fileURLWithPath: gestureDefaultImagePath))
            }catch {
                uLog("解锁图案写入沙盒失败")
            }
        }
    }
    // MARK: -
    func shotView() -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    // MARK: - touch began - moved - end
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureEndResetMembers()
        isTouchBegin = true
        
        currentPoint = .zero
        let point = touches.first!.location(in: self)
        for (_ , circle) in subviews.enumerated() {
            if let circle = circle as? UCircle {
                if circle.frame.contains(point) {
                    circle.state = .selected
                    circleSet.append(circle)
                }
            }
        }
        // 数组中最后一个对象的处理
        circleSetLastObject(state: .lastOneSelected)
        setNeedsDisplay()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoint = .zero
        let point = touches.first!.location(in: self)
        for (_ , circle) in subviews.enumerated() {
            if let circle = circle as? UCircle {
                if circle.frame.contains(point) {
                    if !circleSet.contains(circle) {
                        circleSet.append(circle)
                        // move过程中的连线（包含跳跃连线的处理）
                        calAngleAndconnectTheJumpedCircle()
                    }
                }else {
                    currentPoint = point
                }
            }
        }

        for (_ , circle) in circleSet.enumerated() {
            circle.state = .selected
            // 如果是登录或者验证原手势密码，就改为对应的状态
            if self.gesturesType != .setting {
                circle.state = .lastOneSelected
            }
        }
        // 数组中最后一个对象的处理
        circleSetLastObject(state: .lastOneSelected)
        setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hasClean = false
        var gesture = String()
        for circle in circleSet {
            gesture.append("\(circle.tag)")
        }
        guard gesture.count != 0 else {
            return
        }
        gestureEndHandler(code: gesture)
    }
    // MARK: - 手势结束时的清空操作
    func gestureEndResetMembers() {
        if isTouchBegin {
            isTouchBegin = false
            delegate?.didEndGesture(view: self, type: .setting, image: shotView())
        }
        lock.lock()
        if !hasClean {
            // 手势完毕，选中的圆回归普通状态
            changeCircleInCircleSet(state: .normal)
            // 清空数组
            circleSet.removeAll()
            // 清空方向
            resetAllCirclesDirect()
            // 完成之后改变clean的状态
            hasClean = true
        }
        lock.unlock()
    }
    
    // MARK: - 获取当前选中圆的状态
    func getCircleState() -> UCircle.CircleState {
        return (circleSet.first?.state)!
    }
    
    // MARK: - 改变选中数组CircleSet子控件状态
    func changeCircleInCircleSet(state: UCircle.CircleState) {
        for (idx,circle) in circleSet.enumerated() {
            circle.state = state
            
            if state == .error {
                if idx == circleSet.count - 1 {
                    circle.state = .lastOneError
                }
            }
        }
        self.setNeedsDisplay()
    }
    // MARK: - 清空所有子控件的方向
    func resetAllCirclesDirect() {
        for (_,obj) in subviews.enumerated() {
            if let circle = obj as? UCircle {
                circle.angle = 0
            }
        }
    }
    // MARK: - 对数组中最后一个对象的处理
    func circleSetLastObject(state: UCircle.CircleState) {
        circleSet.last?.state = state
    }
    // MARK: - 将circleSet数组解析遍历，拼手势密码字符串
    func getGestureResultFrom(circleSet: [UCircle]) -> String {
        var gesture = String()
        
        for circle in circleSet {
            gesture.append("\(circle.tag)")
        }
        return gesture
    }
    // MARK: - 设置 手势路径的处理
    func gestureEndHandler(code: String) {
        let length = code.count
        
        switch self.gesturesType {
        case .setting:
            if length < circleSetCountLeast {// 连接少于最少个数 （<4个）
                // 1.通知代理
                delegate?.connectCirclesLessThanNeed(view: self, type: self.gesturesType, gesture: code)
                // 2.改变状态为error
                changeCircleInCircleSet(state: .error)
            }else {// 连接多于最少个数 （>=4个）
                
                //当等于nil或者数量不够
                if Defaults[.gesturePasswordSetingOne] == nil || Defaults[.gesturePasswordSetingOne]!.count < circleSetCountLeast { // 接收并存储第一个密码
                    // 记录第一次密码
                    Defaults[.gesturePasswordSetingOne] = code
                    // 通知代理
                    delegate?.didCompleteSetFirstGesture(view: self, type: self.gesturesType, gesture: code)
                }else {// 接受第二个密码并与第一个密码匹配，一致后存储起来
                    // 匹配两次手势
                    let equal = code == Defaults[.gesturePasswordSetingOne]
                    // 通知代理
                    delegate?.didCompleteSetSecondGesture(view: self, type: self.gesturesType, gesture: code, result: equal)
                    if !equal {
                        changeCircleInCircleSet(state: .error)
                    }
                }
            }
        default:
            let equal = code == Defaults[.gesturePassword]
            delegate?.didCompleteLoginGesture(view: self, type: self.gesturesType, gesture: code, result: equal)
            if !equal {
                changeCircleInCircleSet(state: .error)
            }
        }
        errorToDisplay()
    }
    // MARK: - 是否错误回显重绘
    func errorToDisplay() {
        if getCircleState() == .error || getCircleState() == .lastOneError {
            //DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: handle)
            DispatchQueue.main.asyncAfter(deadline: .now() + displayTime, execute: {
                self.gestureEndResetMembers()
            })
        }else {
            gestureEndResetMembers()
        }
    }
    
    // MARK: - drawRect
    override func draw(_ rect: CGRect) {
        
        if circleSet.isEmpty { return }
        // 绘制图案
        if getCircleState() == .error {
            connectCircles(rect: rect, line: circleConnectLineErrorColor)
        }else {
            connectCircles(rect: rect, line: circleConnectLineNormalColor)
        }
    }
    // MARK: - 连线绘制图案(以设定颜色绘制)
    func connectCircles(rect: CGRect, line color: UIColor) {
        
        //获取上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        //添加路径
        ctx.addRect(rect)
        //是否剪裁
        if clip {
            // 遍历所有子控件
            circleSet.forEach { ctx.addEllipse(in: $0.frame) }
        }
        //剪裁上下文
        ctx.__eoClip()
        
        // 遍历circleSet
        for (idx, circle) in circleSet.enumerated() {
            if idx == 0 {
                // 起点按钮
                ctx.move(to: circle.center)
            }else {
                // 全部是连线
                ctx.addLine(to: circle.center)
            }
        }

        // 连接最后一个按钮到手指当前触摸得点
        if (!currentPoint.equalTo(.zero)) {
            // 遍历所有子控件
            for (_, _) in subviews.enumerated() {
                if getCircleState() == .error || getCircleState() == .lastOneError {
                    // 如果是错误的状态下不连接到当前点
                }else{
                    ctx.addLine(to: currentPoint)
                }
            }

        }

        //线条转角样式
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        // 设置绘图的属性
        ctx.setLineWidth(circleConnectLineWidth)
        // 线条颜色
        color.set()
        //渲染路径
        ctx.strokePath()
    }
    
    // MARK: - 每添加一个圆，就计算一次方向
    func calAngleAndconnectTheJumpedCircle() {
        guard circleSet.count > 1 else {
            return
        }
        //取出最后一个对象
        let lastOne = circleSet.last
        //倒数第二个
        let lastTwo = circleSet[circleSet.count - 2]
        //计算倒数第二个的位置
        let last_1_x: CGFloat = lastOne!.center.x;
        let last_1_y: CGFloat = lastOne!.center.y;
        let last_2_x: CGFloat = lastTwo.center.x;
        let last_2_y: CGFloat = lastTwo.center.y;
        // 1.计算角度（反正切函数）
        let angle: CGFloat = CGFloat(atan2f(Float(last_1_y - last_2_y), Float(last_1_x - last_2_x)) + Float.pi/2)
        lastTwo.angle = angle
        // 2.处理跳跃连线
        let center = centerPoint(pointOne: lastOne!.center, pointTwo: lastTwo.center)
        let centerCircle: UCircle? = enumCircleSetToFindWhichSubviewContainTheCenter(point: center)
        if centerCircle != nil {
            if circleSet.contains(centerCircle!) {
                circleSet.insert(centerCircle!, at: circleSet.count - 1)
            }
        }
        
    }
    // MARK: - 提供两个点，返回一个它们的中点
    func centerPoint(pointOne: CGPoint, pointTwo:CGPoint) -> CGPoint {
        let x1: CGFloat = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x
        let x2: CGFloat = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x
        let y1: CGFloat = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y
        let y2: CGFloat = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y
        return CGPoint(x: (x1+x2)/2, y: (y1 + y2)/2)
    }
    // MARK: - 给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
    /**
     *  给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
     *
     *  @param point 当前点
     *
     *  @return 点所在的圆
     */
    func enumCircleSetToFindWhichSubviewContainTheCenter(point: CGPoint) -> UCircle? {
        var centerCircle: UCircle?
        for (_ , circle) in subviews.enumerated() {
            if circle.frame.contains(point) {
                centerCircle = circle as? UCircle
            }
        }
        guard let uCircle = centerCircle else {
            return nil
        }
        if !circleSet.contains(uCircle) {
            // 这个circle的角度和倒数第二个circle的角度一致
            uCircle.angle = circleSet[circleSet.count - 2].angle
        }
        return uCircle
    }
}
