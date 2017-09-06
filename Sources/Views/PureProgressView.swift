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

protocol HasRing {
    func drawInnerCircle(inView view: UIView)
    func drawOuterArc(inView view: UIView)
}

protocol RingSpinning: HasRing {
    var spinDuration: TimeInterval { get set }
    func startSpinning()
}

protocol ProgressIndicatable: HasRing {
    var progress: Float { get set }
}

class ProgressIndicatableProgressView: UIView, ProgressIndicatable {
    var progress: Float = 0.0
    
    
    func drawOuterArc(inView view: UIView) {
    }
}

class RingSpinningProgressView: UIView, RingSpinning {
    var spinDuration: TimeInterval = 1
    
    private var animator: UIViewPropertyAnimator {
        let angle: CGFloat = 180
        let rotate: () -> Void = {
            self.transform = self.transform.rotated(by: angle.asRadians)
        }
        let animator = UIViewPropertyAnimator(duration: spinDuration, curve: .linear, animations: nil)
        animator.addAnimations(rotate)
        animator.addAnimations(rotate)
        return animator
    }
    
    init() {
        super.init(frame: CGRect(x: 20, y: 20, width: 32, height: 32))
        backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    open override func draw(_ rect: CGRect) {
        drawOuterArc(inView: self)
        drawInnerCircle(inView: self)
        startSpinning()
    }
    
    func drawOuterArc(inView view: UIView) {
        let centerPoint: CGPoint = {
            var point = CGPoint()
            point.x = view.bounds.midX
            point.y = view.bounds.midY
            return point
        }()
        
        let start: CGFloat = -90, end: CGFloat = 132
        let outerArc = UIBezierPath()
        outerArc.move(to: centerPoint)
        outerArc.addArc(withCenter: centerPoint, radius: centerPoint.x, startAngle: start.asRadians, endAngle: end.asRadians, clockwise: true)
        outerArc.close()
        tintColor.setFill()
        outerArc.fill()
    }
    
    func startSpinning() {
        Timer.scheduledTimer(withTimeInterval: spinDuration, repeats: true) { [weak self] _ in
            if let strongSelf = self {
                let animator = strongSelf.animator
                animator.startAnimation()
            }
        }.fire()
    }
}

extension CGFloat {
    var asRadians: CGFloat {
        return self * .pi / 180.0
    }
}

