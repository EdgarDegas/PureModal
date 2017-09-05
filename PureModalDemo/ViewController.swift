//
//  ViewController.swift
//  PureModalDemo
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit
import PureModal

class ViewController: UIViewController {
    @IBAction func presentDefaultAlertButtonTapped(_ sender: UIButton) {
        let alertController = PureAlertController()
        alertController.title = "Changed Title with Title"
        alertController.alertMessage = "message message message"
        alertController.delegate = self
        alertController.modal(animated: true, for: self)
    }
    
    @IBAction func presentAutoDismissAlertButtonTapped(_ sender: UIButton) {
        let autoDismissAlertController = PureAlertController()
        autoDismissAlertController.alertTitle = "Not Signed In"
        autoDismissAlertController.alertMessage = "Sign in to continue."
        autoDismissAlertController.alertStyle = .autoDismiss(after: 1.5)
        autoDismissAlertController.delegate = self
        autoDismissAlertController.modal(animated: true, for: self)
    }
    
    @IBAction func presentDialogueAlertButtonTapped(_ sender: UIButton) {
        let dialogueAlertController = PureAlertController()
        dialogueAlertController.title = "Title"
        dialogueAlertController.alertTitle = "Are you Sure"
        dialogueAlertController.alertStyle = .dialogue(cancelButtonTitle: nil, confirmButtonTitle: nil)
        dialogueAlertController.delegate = self
        dialogueAlertController.modal(animated: true, for: self)
    }
    
    @IBAction func presentProgressAlertButtonTapped(_ sender: UIButton) {
        let progressAlertController = PureAlertController()
        progressAlertController.alertStyle = .progressIndicator(ofStyle: .spinning)
        progressAlertController.delegate = self
        progressAlertController.modal(animated: true, for: self)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            progressAlertController.dismiss()
        }
    }
}

extension ViewController: PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didReachDismissTimeout timeout: TimeInterval) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapOutsideArea area: UIView?) {
        switch controller.alertStyle! {
        case .autoDismiss:
            controller.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapNonButtonArea area: UIView?) {
        switch controller.alertStyle! {
        case .autoDismiss:
            controller.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
