//
//  PureAlertController.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public protocol PureAlertControllerDelegate: PureModalControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton)
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapConfirmButton confirmButton: UIButton)
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didReachDismissTimeout timeout: TimeInterval)
}

public extension PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton) { }
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapConfirmButton confirmButton: UIButton) { }
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didReachDismissTimeout timeout: TimeInterval) { }
}

open class PureAlertController: PureModalController {
    
    // MARK: - Variables and Interface
    
    open override var title: String? {
        get { return modalTitle }
        set { modalTitle = newValue }
    }
    
    public var alertStyle = PureAlertViewStyle.default(buttonTitle: nil)
    var shouldPresentedAnimated: Bool!
    
    public weak var delegate: PureAlertControllerDelegate?
    
    convenience public init(withTitle title: String?, message: String?, withStyle style: PureAlertViewStyle?) {
        self.init()
        modalTitle = title
        modalMessage = message
        if style != nil {
            alertStyle = style!
        }
    }
    
    open func modal(animated: Bool, for viewController: UIViewController) {
        modalPresentationStyle = .overCurrentContext
        shouldPresentedAnimated = animated
        loadWindow()
        loadAlertView()
        viewController.present(self, animated: true, completion: nil)
        if shouldPresentedAnimated {
            modalPresentingHelper.presentAlert(for: viewController)
        }
    }
    
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            modalPresentingHelper.dismissAlert(completion: completion)
        } else {
            window = nil
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    /// Dismiss alert view with animation.
    ///
    /// To avoid animation, use dismiss(animated:completion:) instead.
    /// - Parameter completion: Block of code executed upon animation finished.
    open func dismiss(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.window.frame = UIScreen.main.bounds
            self.window.rootViewController?.view.frame = UIScreen.main.bounds
        }
    }
    
    
    // MARK: - Initialization
    
    public override func loadWindow() {
        window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = UIWindowLevelAlert
            window.rootViewController = UIViewController()
            window.rootViewController?.view.frame = UIScreen.main.bounds
            window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
            return window
        }()
        window.makeKeyAndVisible()
        window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideAreaTapped(sender:))))
    }
    
    @objc private func outsideAreaTapped(sender recognizer: UIGestureRecognizer) {
        delegate?.modalController(self, didTapOuterAreaOfModalView: innerView)
    }
    
    private func loadAlertView() {
        innerView = PureAlertView(withTitle: modalTitle, message: modalMessage, style: alertStyle)
        if let tintColor = tintColor {
            innerView.tintColor = tintColor
        }
        
        (innerView as! PureAlertView).delegate = self
        (innerView as! PureAlertView).addTo(view: window.rootViewController!.view)
    }
}


// MARK: - Pure alert view delegate

extension PureAlertController: PureAlertViewDelegate {
    public func modalView(_ modalView: PureModalView, didTapNonButtonArea area: UIView?) {
        delegate?.modalController(self, didTapNonButtonArea: area, ofModalView: modalView)
    }
    
    func alertView(_ alertView: PureAlertView, didTapCancelButton cancelButton: UIButton) {
        delegate?.alertView(alertView, in: self, didTapCancelButton: cancelButton)
    }
    
    func alertView(_ alertView: PureAlertView, didTapConfirmButton confirmButton: UIButton) {
        delegate?.alertView(alertView, in: self, didTapConfirmButton: confirmButton)
    }
    
    func alertView(_ alertView: PureAlertView, didReachDismissTimeout timeout: TimeInterval) {
        delegate?.alertView(alertView, in: self, didReachDismissTimeout: timeout)
    }
}
