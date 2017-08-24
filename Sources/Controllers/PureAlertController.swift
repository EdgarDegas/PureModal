//
//  PureAlertController.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public protocol PureAlertControllerDelegate: class {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton)
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapConfirmButton confirmButton: UIButton)
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapNonButtonArea area: UIView?)
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapOutsideArea area: UIView?)
}

public extension PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton) { }
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapConfirmButton confirmButton: UIButton) { }
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapNonButtonArea area: UIView?) { }
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapOutsideArea area: UIView?) { }
}

open class PureAlertController: UIViewController {
    
    // MARK: - Variables and Interface
    
    public var tintColor: UIColor?
    var shouldPresentedAnimated: Bool!
    var window: UIWindow!
    var alertView: PureAlertView!
    public weak var delegate: PureAlertControllerDelegate?
    
    convenience public init(withTitle title: String?, message: String?, withStyle style: PureAlertViewStyle) {
        self.init()
    }
    
    open func modal(animated: Bool, for viewController: UIViewController) {
        modalPresentationStyle = .overCurrentContext
        shouldPresentedAnimated = animated
        viewController.present(self, animated: true, completion: nil)
    }
    
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWindow()
        self.loadAlertView()
        if shouldPresentedAnimated {
            animatedFadeIn()
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            animatedFadeOut(completion: completion)
        } else {
            window = nil
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    open func dismiss(completion: (() -> Void)? = nil) {
        animatedFadeOut(completion: completion)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.window.frame = UIScreen.main.bounds
            self.window.rootViewController?.view.frame = UIScreen.main.bounds
        }
    }
    
    // MARK: - Initialization
    
    private func loadWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.makeKeyAndVisible()
        window.rootViewController = UIViewController()
        window.rootViewController?.view.frame = UIScreen.main.bounds
        self.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideAreaTapped(sender:))))
    }
    
    @objc private func outsideAreaTapped(sender recognizer: UIGestureRecognizer) {
        delegate?.alertView(alertView, in: self, didTapOutsideArea: recognizer.view)
    }
    
    private func loadAlertView() {
        alertView = PureAlertView(withTitle: "标题", message: "标准样式模态框，带一个标题，一个消息，一个按钮\n示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本示例文本", style: .default(buttonTitle: "完成"))
        if let tintColor = tintColor {
            alertView.tintColor = tintColor
        }
        alertView.delegate = self
        alertView.addTo(view: window.rootViewController!.view)
    }
}


// MARK: - Pure alert fade animation
extension PureAlertController {
    private func animatedFadeIn() {
        self.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0)
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let windowAnimator = UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
            self.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        }
        let timeParameters = UISpringTimingParameters(mass: 0.68, stiffness: 120, damping: 16.8, initialVelocity: CGVector(dx: 14, dy: 14))
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
        animator.addAnimations {
            self.alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        windowAnimator.startAnimation()
        animator.startAnimation()
    }
    
    private func animatedFadeOut(completion: (() -> Void)?) {
        for subview in alertView.subviews {
            subview.isHidden = true
        }
        let windowAnimator = UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
            self.window.rootViewController!.view.backgroundColor = UIColor(white: 0, alpha: 0)
        }
        let timeParameters = UISpringTimingParameters(mass: 0.1, stiffness: 120, damping: 1000, initialVelocity: CGVector(dx: 8, dy: 8))
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
        animator.addAnimations {
            self.alertView.transform = CGAffineTransform(scaleX: 0.68, y: 0.68)
            self.alertView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        windowAnimator.addCompletion { _ in
            self.window = nil
            super.dismiss(animated: false, completion: completion)
        }
        windowAnimator.startAnimation()
        animator.startAnimation()
    }
}


// MARK: - Pure alert view delegate

extension PureAlertController: PureAlertViewDelegate {
    func alertView(_ alertView: PureAlertView, didTapNonButtonArea area: UIView?) {
        delegate?.alertView(alertView, in: self, didTapNonButtonArea: area)
    }
    
    func alertView(_ alertView: PureAlertView, didTapCancelButton cancelButton: UIButton) {
        delegate?.alertView(alertView, in: self, didTapCancelButton: cancelButton)
    }
    
    func alertView(_ alertView: PureAlertView, didTapConfirmButton confirmButton: UIButton) {
        delegate?.alertView(alertView, in: self, didTapConfirmButton: confirmButton)
    }
}
