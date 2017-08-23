//
//  PureAlertController.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

public protocol PureAlertControllerDelegate: class {
    func alertView(_ alertView: PureAlertView, didClickCancelButton cancelButton: UIButton)
    func alertView(_ alertView: PureAlertView, didClickConfirmButton confirmButton: UIButton)
}

public extension PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, didClickCancelButton cancelButton: UIButton) { }
    func alertView(_ alertView: PureAlertView, didClickConfirmButton confirmButton: UIButton) { }
}

open class PureAlertController: UIViewController {
    
    // MARK: - Variables and Interface
    
    var window: UIWindow!
//    var alertView: UIView!
    var alertView: PureAlertView!
    weak var viewController: UIViewController?
    weak var delegate: PureAlertControllerDelegate?
    
    open func modal(for viewController: UIViewController) {
        self.viewController = viewController
        modalPresentationStyle = .overCurrentContext
        viewController.present(self, animated: true, completion: nil)
    }
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        loadWindow()
        loadAlertView()
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
        window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
    
    private func loadAlertView() {
        alertView = PureAlertView(withTitle: "Title", message: "messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage", style: .default(buttonTitle: "OK"))
        alertView.delegate = self
        alertView.addTo(view: window)
    }
}

extension PureAlertController: PureAlertViewDelegate {
    
}
