//
//  PureProgressView.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/25.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public enum PureProgressViewStyle {
    case spinning
    case progress
}

open class PureProgressView: UIView {
    var style: PureProgressViewStyle!
    
    convenience public init(withStyle style: PureProgressViewStyle) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.style = style
    }
    
    open override func draw(_ rect: CGRect) {
        let centerPoint: CGPoint = {
            var point = CGPoint()
            point.x = self.bounds.midX
            point.y = self.bounds.midY
            return point
        }()
        
        let innerRect: CGRect = {
            let ringWidth: CGFloat = 9
            let width = self.bounds.size.width - ringWidth * 2
            
            let size = CGSize(width: width, height: width)
            let origin = CGPoint(x: ringWidth, y: ringWidth)
            return CGRect(origin: origin, size: size)
        }()
        
        switch style {
        case .spinning:
            let outerArc = UIBezierPath(arcCenter: centerPoint, radius: centerPoint.x, startAngle: -55, endAngle: 55, clockwise: true)
            tintColor.setFill()
            outerArc.fill()
            
            let innerCircle = UIBezierPath(ovalIn: innerRect)
            self.superview?.backgroundColor?.setFill()
            innerCircle.fill()
        default:
            break
        }
    }
}
