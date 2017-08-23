//
//  PureAlertView.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

/// Style of Pure Alert View.
///
/// - `default`: The default style with title, message and a cancel button (default title: OK)
/// - autoDismiss: A box with title, message. Disappear after some time (default length: 2 seconds)
/// - dialogue: A dialogue box with title, message and two buttons.
public enum PureAlertViewStyle {
    
    /// Title, message and a cancel button (default title: OK)
    case `default`(String?)
    
    /// Title, message. Disappear after some time (default length: 2 seconds)
    case autoDismiss(TimeInterval?)
    
    /// Title, message, and two button:
    /// - a cancel button (default title: No)
    /// - a confirm button (defualt title: Yes)
    case dialogue(String?, String?)
}

open class PureAlertView: UIView {
    open var titleLabel: UILabel?
    open var messageLabel: UILabel?
    open var cancelButton: UIButton?
    open var confirmButton: UIButton?
    open var dismissTimeout: TimeInterval?
    
    convenience public init(withStyle style: PureAlertViewStyle) {
        self.init()
        switch style {
        case .default(let buttonTitle):
            if let title = buttonTitle {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle(title, for: .normal)
            }
        case .autoDismiss(let timeoutOfDismiss):
            dismissTimeout = timeoutOfDismiss
        case .dialogue(let cancelTitle, let confirmTitle):
            if let cancel = cancelTitle {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle(cancel, for: .normal)
            }
            if let confirm = confirmTitle {
                confirmButton = UIButton(type: .system)
                confirmButton?.setTitle(confirm, for: .normal)
            }
        }
    }
}
