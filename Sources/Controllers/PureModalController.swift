//
//  PureModalController.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/10.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

open class PureModalController: UIViewController, PureModal {
    public func loadWindow() {
        fatalError("Must inherit.")
    }
    
    public var tintColor: UIColor?
    
    public var window: UIWindow!
    
    public lazy var modalPresentingHelper = PureModalPresentingHelper(owner: self)
    
    public var modalTitle: String?
    
    public var modalMessage: String?
    
    public var innerView: PureModalView!
    
    public typealias InnerView = PureModalView
}
