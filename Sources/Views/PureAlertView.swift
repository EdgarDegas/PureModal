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
enum PureAlertViewStyle {
    /// Title, message and a cancel button (default title: OK)
    case `default`
    /// Title, message. Disappear after some time (default length: 2 seconds)
    case autoDismiss
    /// Title, message, and two button:
    /// - a cancel button (default title: No)
    /// - a comfirm button (defualt title: Yes)
    case dialogue
}

class PureAlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
