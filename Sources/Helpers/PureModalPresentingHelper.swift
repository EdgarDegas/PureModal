//
//  PureModalPresentingHelper.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/13.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import Foundation

public enum PureModalBackgroundRenderMode {
    case obscure
    case prominentBlur
}

public class PureModalPresentingHelper {
    weak var owner: PureModalController?
    private var backgroundRenderMode: PureModalBackgroundRenderMode

    init(owner: PureModalController, withBackgroundRenderMode mode: PureModalBackgroundRenderMode) {
        self.owner = owner
        self.backgroundRenderMode = mode
    }
    
    func presentAlert(for controller: UIViewController) {
        guard let alertController = owner else {
            return
        }
        alertController.innerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        let alertViewAnimator: UIViewPropertyAnimator = {
            let timeParameters = UISpringTimingParameters(mass: 0.68, stiffness: 120, damping: 16.8, initialVelocity: CGVector(dx: 14, dy: 14))
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
            animator.addAnimations {
                alertController.innerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            return animator
        }()
        
        switch backgroundRenderMode {
        case .obscure:
            obscureBackground(for: alertController)
        case .prominentBlur:
            prominentBlurBackground(for: alertController)
        }
        alertViewAnimator.startAnimation()
    }
    
    func dismissAlert(completion: (() -> Void)?) {
        guard let alertController = owner as? PureAlertController else {
            return
        }
        for subview in alertController.innerView.subviews {
            subview.isHidden = true
        }

        let alertViewAnimator: UIViewPropertyAnimator = {
            let timeParameters = UISpringTimingParameters(mass: 0.1, stiffness: 120, damping: 1000, initialVelocity: CGVector(dx: 8, dy: 8))
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
            animator.addAnimations {
                alertController.innerView.transform = CGAffineTransform(scaleX: 0.68, y: 0.68)
                alertController.innerView.backgroundColor = UIColor(white: 1, alpha: 0)
            }
            return animator
        }()
        
        switch backgroundRenderMode {
        case .obscure:
            recoverObscuredBackground(for: alertController, completion: completion)
        case .prominentBlur:
            recoverProminentBluredBackground(for: alertController, completion: completion)
        }
        alertViewAnimator.startAnimation()
    }
    
    
    private func obscureBackground(for controller: PureModalController) {
        controller.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0)
        let windowAnimator: UIViewPropertyAnimator = {
            return UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
                controller.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
            }
        }()
        windowAnimator.startAnimation()
    }
    
    private func recoverObscuredBackground(for controller: PureModalController, completion: (() -> Void)?) {
        let windowAnimator: UIViewPropertyAnimator = {
            let animator = UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
                controller.window.rootViewController!.view.backgroundColor = UIColor(white: 0, alpha: 0)
            }
            animator.addCompletion { _ in
                controller.window = nil
                controller.dismiss(animated: false, completion: completion)
            }
            return animator
        }()
        windowAnimator.startAnimation()
    }
    
    private func prominentBlurBackground(for controller: PureModalController) {
        
    }
    
    private func recoverProminentBluredBackground(for controller: PureModalController, completion: (() -> Void)?) {
        
    }
}
