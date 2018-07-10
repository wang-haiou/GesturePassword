//
//  UCircle.swift
//  GesturePassword
//
//  Created by Seagull on 2018/1/17.
//  Copyright © 2018年 Seagull. All rights reserved.
//

import UIKit

class UCircle: UIView {

    enum CircleState {
        case normal,selected,error,lastOneSelected,lastOneError
        
        /**
         *  圆环绘制颜色的getter
         */
        func outCircleColor() -> UIColor {
            switch (self) {
            case .normal:
                return circleStateNormalOutsideColor
            case .selected:
                return circleStateSelectedOutsideColor;
            case .error:
                return circleStateErrorOutsideColor;
            case .lastOneSelected:
                return circleStateSelectedOutsideColor;
            case .lastOneError:
                return circleStateErrorOutsideColor;
            }
        }
        /**
         *  实心圆绘制颜色的getter
         */
        func inCircleColor() -> UIColor {
            switch (self) {
            case .normal:
                return circleStateNormalInsideColor
            case .selected:
                return circleStateSelectedInsideColor;
            case .error:
                return circleStateErrorInsideColor;
            case .lastOneSelected:
                return circleStateSelectedInsideColor;
            case .lastOneError:
                return circleStateErrorInsideColor;
            }
        }
        /**
         *  三角形颜色的getter
         */
        func trangleColor() -> UIColor {
            switch (self) {
            case .normal:
                return circleStateNormalTrangleColor
            case .selected:
                return circleStateSelectedTrangleColor;
            case .error:
                return circleStateErrorTrangleColor;
            case .lastOneSelected:
                return circleStateNormalTrangleColor;
            case .lastOneError:
                return circleStateNormalTrangleColor;
            }
        }
        
    }

    enum CircleType {
        case original //带有圆心的
        case hollow //空心的
    }
    
    var state: CircleState = .normal {
        didSet{
            setNeedsDisplay()
        }
    }
    var type :CircleType = .original
    
    //是否有箭头 default is true
    var arrow: Bool = true {
        didSet{
            self.setNeedsDisplay()
        }
    }
    //角度
    var angle: CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = circleBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = circleBackgroundColor
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let circleRect = CGRect(x: circleEdgeWidth, y: circleEdgeWidth, width: rect.size.width - 2 * circleEdgeWidth, height: rect.size.height - 2 * circleEdgeWidth)
        
        var radio: CGFloat = 1.0
        if type == .original {
            radio = circleRadio
        }else if type == .hollow {
            radio = 1.0
        }
        // 上下文旋转
        self.transForm(ctx: context, rect: rect)
        // 画圆环
        self.drawEmptyCircleWithContext(context, rect: circleRect, color: state.outCircleColor())
        // 画实心圆
        self.drawSolidCircleWithContext(context, rect: rect, radio: radio, color: state.inCircleColor())
        
        if arrow {
            // 画三角形箭头
            self.drawTrangle(context, topPoint: CGPoint(x: rect.size.width/2, y: 10.0), length: kTrangleLength, color: state.trangleColor())
        }
    }
    
    // MARK: - 上下文旋转
    func transForm(ctx:CGContext, rect: CGRect) {
        let translateXY = rect.width * 0.5
        
        // 平移
        ctx.translateBy(x: translateXY, y: translateXY)
        
        ctx.rotate(by: angle)
        
        // 再平移回来
        ctx.translateBy(x: -translateXY, y: -translateXY)
    }
    
    // MARK: - 画外圆环
    /**
     *  画外圆环
     *
     *  @param ctx   图形上下文
     *  @param rect  绘画范围
     *  @param color 绘制颜色
     */
    func drawEmptyCircleWithContext(_ ctx: CGContext, rect: CGRect, color:UIColor) {
        let circlePath = CGMutablePath()
        circlePath.addEllipse(in: rect)
        ctx.addPath(circlePath)
        color.set()
        ctx.setLineWidth(circleEdgeWidth)
        ctx.strokePath()
    }

    // MARK: - 画实心圆
    /**
     *  画实心圆
     *
     *  @param ctx   图形上下文
     *  @param rect  绘制范围
     *  @param radio 占大圆比例
     *  @param color 绘制颜色
     */
    func drawSolidCircleWithContext(_ ctx: CGContext, rect: CGRect,radio:CGFloat,
                                    color:UIColor) {
        let circlePath = CGMutablePath()
        circlePath.addEllipse(in: CGRect(x: rect.size.width/2 * (1 - radio) + circleEdgeWidth, y: rect.size.height/2 * (1 - radio) + circleEdgeWidth, width: rect.size.width * radio - circleEdgeWidth * 2, height: rect.size.height * radio - circleEdgeWidth * 2))
        color.set()
        ctx.addPath(circlePath)
        ctx.fillPath()
    }
    
    // MARK: - 画三角形
    /**
     *  画三角形
     *
     *  @param ctx    图形上下文
     *  @param point  顶点
     *  @param length 边长
     *  @param color  绘制颜色
     */
    func drawTrangle(_ ctx: CGContext, topPoint: CGPoint, length:CGFloat, color:UIColor) {
        
        let trianglePathM = CGMutablePath()
        
        trianglePathM.move(to: topPoint)
        trianglePathM.addLine(to: CGPoint(x: topPoint.x-length/2, y: topPoint.y+length/2))
        trianglePathM.addLine(to: CGPoint(x: topPoint.x+length/2, y: topPoint.y+length/2))
        ctx.addPath(trianglePathM)
        color.set()
        ctx.fillPath()
    }
}
