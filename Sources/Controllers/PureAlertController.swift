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
    var window: UIWindow!
    var alertView: PureAlertView!
    public weak var delegate: PureAlertControllerDelegate?
    
    open func modal(for viewController: UIViewController) {
        modalPresentationStyle = .overCurrentContext
        viewController.present(self, animated: true, completion: nil)
        loadWindow()
        loadAlertView()
    }
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        window = nil
        super.dismiss(animated: flag, completion: completion)
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
        window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
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
