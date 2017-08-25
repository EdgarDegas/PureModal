//
//  PureProgressView.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/25.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public enum PureProgressViewStyle {
    case circle
    case line
}

open class PureProgressView: UIView {
    var progress: Float? = 0.6
    var style: PureProgressViewStyle
    
    convenience init(withStyle style: PureProgressViewStyle) {
        self.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.style = style
    }
    
    override private init(frame: CGRect) {
        style = .circle
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        style = .circle
        super.init(coder: aDecoder)
    }
    
    open override func draw(_ rect: CGRect) {
        switch style {
        case .circle:
            let oval = UIBezierPath(ovalIn: rect)
            UIColor.black.setStroke()
            oval.stroke()
            
            let innerOrigin = CGPoint(x: rect.origin.x + rect.width / 4, y: rect.origin.y + rect.height / 4)
            let innerSize = CGSize(width: rect.size.width / 2, height: rect.size.height / 2)
            let innerRect = CGRect(origin: innerOrigin, size: innerSize)
            let innerOval = UIBezierPath(ovalIn: innerRect)
            innerOval.stroke()
        case .line: break
        }
    }
}
