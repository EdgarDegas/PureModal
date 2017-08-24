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
    case `default`(buttonTitle: String?)
    
    /// Title, message. Disappear after some time (default length: 2 seconds)
    case autoDismiss(after: TimeInterval?)
    
    /// Title, message, and two button:
    /// - a cancel button (default title: No)
    /// - a confirm button (defualt title: Yes)
    case dialogue(cancelButtonTitle: String?, confirmButtonTitle: String?)
}

protocol PureAlertViewDelegate: class {
    func alertView(_ alertView: PureAlertView, didTapCancelButton cancelButton: UIButton)
    func alertView(_ alertView: PureAlertView, didTapConfirmButton confirmButton: UIButton)
    func alertView(_ alertView: PureAlertView, didTapNonButtonArea area: UIView?)
}

open class PureAlertView: UIView {
    
    // MARK: - Variables

    open var titleLabel: UILabel?
    open var messageLabel: UILabel?
    open var cancelButton: UIButton?
    open var confirmButton: UIButton?
    open var dismissTimeout: TimeInterval?
    
    weak var delegate: PureAlertViewDelegate?
    
    // MARK: - Interface
    
    func addTo(view superView: UIView) {
        superView.addSubview(self)
        centerXAnchor.constraint(equalTo: superView.centerXAnchor)
            .isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor)
            .isActive = true
        widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -120)
            .isActive = true
    }
    
    
    convenience public init(withTitle title: String?, message: String?, style: PureAlertViewStyle) {
        self.init()
        setupAppearance()
        
        if let title = title {
            titleLabel = UILabel()
            titleLabel?.text = title
        }
        if let message = message {
            messageLabel = UILabel()
            messageLabel?.text = message
        }
        switch style {
        case .default(let buttonTitle):
            if let title = buttonTitle {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle(title, for: .normal)
            }
            loadDefaultAlertView()
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
    
    private func setupAppearance() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nonButtonAreaTapped(sender:))))
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        backgroundColor = UIColor.white
    }
    
    @objc private func nonButtonAreaTapped(sender recognizer: UIGestureRecognizer) {
        delegate?.alertView(self, didTapNonButtonArea: recognizer.view)
        print("nonButtonAreaTapped")
    }
    
    private func loadDefaultAlertView() {
        func loadCancelButton(under topToAnchor: NSLayoutYAxisAnchor) {
            if cancelButton == nil {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle("Cancel", for: .normal)
            }
            cancelButton?.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(cancelButton!)
            cancelButton?.topAnchor.constraint(equalTo: topToAnchor, constant: 20)
                .isActive = true
            cancelButton?.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
                .isActive = true
            cancelButton?.centerXAnchor.constraint(equalTo: centerXAnchor)
                .isActive = true
        }
        
        if let titleAndMessageStack = loadTitleAndMessage() {
            titleAndMessageStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleAndMessageStack)
            titleAndMessageStack.topAnchor.constraint(equalTo: topAnchor, constant: 20)
                .isActive = true
            titleAndMessageStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -40)
                .isActive = true
            titleAndMessageStack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                .isActive = true
            loadCancelButton(under: titleAndMessageStack.bottomAnchor)
        } else {
            loadCancelButton(under: topAnchor)
        }
        
    }
    
    private func loadTitleAndMessage() -> UIStackView? {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        if let titleLabel = titleLabel {
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.numberOfLines = 4
            stackView.addArrangedSubview(titleLabel)
        }
        if let messageLabel = messageLabel {
            messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
            messageLabel.textColor = #colorLiteral(red: 0.4168450832, green: 0.4168450832, blue: 0.4168450832, alpha: 1)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.lineBreakMode = .byTruncatingTail
            messageLabel.numberOfLines = 16
            stackView.addArrangedSubview(messageLabel)
        }
        if stackView.arrangedSubviews.isEmpty {
            return nil
        } else {
            return stackView
        }
    }
}

extension PureAlertView {
    @objc private func cancelButtonTapped(sender button: UIButton) {
        delegate?.alertView(self, didTapCancelButton: button)
    }
}
