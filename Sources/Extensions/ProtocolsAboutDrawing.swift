//
//  ProtocolsAboutDrawing.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/9/6.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

extension HasRing {
    func drawInnerCircle(inView view: UIView) {
        let innerRect: CGRect = {
            let ringWidth: CGFloat = 3.6
            let width = view.bounds.size.width - ringWidth * 2
            
            let size = CGSize(width: width, height: width)
            let origin = CGPoint(x: ringWidth, y: ringWidth)
            return CGRect(origin: origin, size: size)
        }()
        
        let innerCirclePath = UIBezierPath(ovalIn: innerRect)
        UIColor.white.setFill()
        innerCirclePath.fill()
    }
}
