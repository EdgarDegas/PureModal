//
//  PureCardView.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/10.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

open class PureCardView: PureModalView {
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backgroundColor = UIColor.white
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func addTo(view superView: UIView) {
        superView.addSubview(self)
        centerXAnchor.constraint(equalTo: superView.centerXAnchor)
            .isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -20)
            .isActive = true
        widthAnchor.constraint(equalTo: super.widthAnchor, constant: -24)
            .isActive = true
        heightAnchor.constraint(equalToConstant: 200)
            .isActive = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
