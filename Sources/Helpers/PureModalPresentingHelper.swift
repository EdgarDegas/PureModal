//
//  PureModalPresentingHelper.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/10/13.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import Foundation

public class PureModalPresentingHelper {
    weak var owner: PureModalController?
    
    init(owner: PureModalController) {
        self.owner = owner
    }
    
    func presentAlert(for controller: UIViewController) {
        guard let alertController = owner else {
            return
        }
        
        alertController.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0)
        alertController.innerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        let windowAnimator: UIViewPropertyAnimator = {
            return UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
                alertController.window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
            }
        }()

        let alertViewAnimator: UIViewPropertyAnimator = {
            let timeParameters = UISpringTimingParameters(mass: 0.68, stiffness: 120, damping: 16.8, initialVelocity: CGVector(dx: 14, dy: 14))
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
            animator.addAnimations {
                alertController.innerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            return animator
        }()
        
        windowAnimator.startAnimation()
        alertViewAnimator.startAnimation()
    }
    
    func dismissAlert(completion: (() -> Void)?) {
        guard let alertController = owner as? PureAlertController else {
            return
        }
        for subview in alertController.innerView.subviews {
            subview.isHidden = true
        }
        
        let windowAnimator: UIViewPropertyAnimator = {
            let animator = UIViewPropertyAnimator(duration: 0.16, curve: .easeOut) {
                alertController.window.rootViewController!.view.backgroundColor = UIColor(white: 0, alpha: 0)
            }
            animator.addCompletion { _ in
                alertController.window = nil
                alertController.dismiss(animated: false, completion: completion)
            }
            return animator
        }()
        
        let alertViewAnimator: UIViewPropertyAnimator = {
            let timeParameters = UISpringTimingParameters(mass: 0.1, stiffness: 120, damping: 1000, initialVelocity: CGVector(dx: 8, dy: 8))
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timeParameters)
            animator.addAnimations {
                alertController.innerView.transform = CGAffineTransform(scaleX: 0.68, y: 0.68)
                alertController.innerView.backgroundColor = UIColor(white: 1, alpha: 0)
            }
            return animator
        }()
        
        windowAnimator.startAnimation()
        alertViewAnimator.startAnimation()
    }
    
    private func obscuresBackground() {
        
    }
    
    private func recoverObscuredBackground() {
        
    }
    
    private func motionBlurBackground() {
        
    }
    
    private func recoverMotionBluredBackground() {
        
    }
}
