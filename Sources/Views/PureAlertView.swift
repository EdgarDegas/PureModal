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
/// - `default`: The default style with title, message and a cancel button (default title: OK).
/// - autoDismiss: A box with title, message. Disappear after some time (default length: 2 seconds).
/// - progressIndicator: A box with title, message and a progress view (default style: circle).
/// - dialogue: A dialogue box with title, message and two buttons.
public enum PureAlertViewStyle {
    
    /// Title, message and a cancel button (default title: OK)
    case `default`(buttonTitle: String?)
    
    /// Title, message. Disappear after some time (default length: 2 seconds)
    case autoDismiss(after: TimeInterval?)
    
    /// Title, message, and a progress view (default style: circle)
    case progressIndicator(ofStyle: PureProgressViewStyle?)
    
    /// Title, message, and two button:
    /// - a cancel button (default title: No)
    /// - a confirm button (defualt title: Yes)
    case dialogue(cancelButtonTitle: String?, confirmButtonTitle: String?)
}

protocol PureAlertViewDelegate: PureModalViewDelegate {
    func alertView(_ alertView: PureAlertView, didTapCancelButton cancelButton: UIButton)
    func alertView(_ alertView: PureAlertView, didTapConfirmButton confirmButton: UIButton)
    func alertView(_ alertView: PureAlertView, didReachDismissTimeout timeout: TimeInterval)
}

open class PureAlertView: PureModalView {
    
    // MARK: - Variables

    open var titleLabel: UILabel?
    open var messageLabel: UILabel?
    open var cancelButton: UIButton?
    open var confirmButton: UIButton?
    open var dismissTimeout: TimeInterval?
    
    weak var delegate: PureAlertViewDelegate?
    private var style: PureAlertViewStyle!
    
    private enum AutoLayoutConstants {
        static let padding: CGFloat = 20
        static let indicatorWidth: CGFloat = 24
    }
    
    // MARK: - Interface
    
    func addTo(view superView: UIView) {
        superView.addSubview(self)
        centerXAnchor.constraint(equalTo: superView.centerXAnchor)
            .isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor)
            .isActive = true
        switch style! {
        case .progressIndicator:
            if messageLabel != nil || titleLabel != nil {
                widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -120)
                    .isActive = true
            } else {
                let width = AutoLayoutConstants.padding * 2 + AutoLayoutConstants.indicatorWidth
                widthAnchor.constraint(equalToConstant: width)
                    .isActive = true
                layer.cornerRadius = width / 2
            }
        default:
            widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -120)
                .isActive = true
        }
    }
    
    convenience public init(withTitle title: String?, message: String?, style: PureAlertViewStyle) {
        self.init()
        setupAppearance()
        self.style = style
        
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
            loadAutoDismissAlertView()
        case .dialogue(let cancelTitle, let confirmTitle):
            if let cancel = cancelTitle {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle(cancel, for: .normal)
            }
            if let confirm = confirmTitle {
                confirmButton = UIButton(type: .system)
                confirmButton?.setTitle(confirm, for: .normal)
                confirmButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            }
            loadDialogueAlertView()
        case .progressIndicator(let style):
            if let style = style {
                if style == .progress {
                    loadProgressView(ProgressIndicatableProgressView())
                } else {
                    loadProgressView(RingSpinningProgressView())
                }
            } else {
                loadProgressView(RingSpinningProgressView())
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
        delegate?.modalView(self, didTapNonButtonArea: recognizer.view)
    }
    
    
    // MARK: - load view methods
    
    private func loadDefaultAlertView() {
        func loadCancelButton(under topToAnchor: NSLayoutYAxisAnchor) {
            if cancelButton == nil {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle("Cancel", for: .normal)
            }
            cancelButton?.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(cancelButton!)
            cancelButton?.topAnchor.constraint(equalTo: topToAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            cancelButton?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
            cancelButton?.centerXAnchor.constraint(equalTo: centerXAnchor)
                .isActive = true
        }
        
        if let titleAndMessageStack = titleAndMessageStack {
            titleAndMessageStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleAndMessageStack)
            titleAndMessageStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            titleAndMessageStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -AutoLayoutConstants.padding * 2)
                .isActive = true
            titleAndMessageStack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                .isActive = true
            loadCancelButton(under: titleAndMessageStack.bottomAnchor)
        } else {
            loadCancelButton(under: topAnchor)
        }
    }
    
    private func loadAutoDismissAlertView() {
        var timeout: TimeInterval = 2
        if dismissTimeout != nil {
            timeout = dismissTimeout!
        }
        if timeout > 0 {
            let notifyDelegateWorkItem = DispatchWorkItem(block: {
                self.delegate?.alertView(self, didReachDismissTimeout: timeout)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: notifyDelegateWorkItem)
        }
        
        if let titleAndMessageStack = titleAndMessageStack {
            titleAndMessageStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleAndMessageStack)
            titleAndMessageStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            titleAndMessageStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -AutoLayoutConstants.padding * 2)
                .isActive = true
            titleAndMessageStack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                .isActive = true
            titleAndMessageStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
        }
    }
    
    private func loadDialogueAlertView() {
        func loadCancelAndConfirmButtonStack(under topToAnchor: NSLayoutYAxisAnchor) {
            if cancelButton == nil {
                cancelButton = UIButton(type: .system)
                cancelButton?.setTitle("Cancel", for: .normal)
            }
            if confirmButton == nil {
                confirmButton = UIButton(type: .system)
                confirmButton?.setTitle("Confirm", for: .normal)
                confirmButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            }
            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
            confirmButton?.translatesAutoresizingMaskIntoConstraints = false
            cancelButton?.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
            confirmButton?.addTarget(self, action: #selector(confirmButtonTapped(sender:)), for: .touchUpInside)
            
            let cancelAndConfirmButtonStack = UIStackView(arrangedSubviews: [cancelButton!, confirmButton!])
            cancelAndConfirmButtonStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(cancelAndConfirmButtonStack)
            cancelAndConfirmButtonStack.axis = .horizontal
            cancelAndConfirmButtonStack.alignment = .center
            cancelAndConfirmButtonStack.distribution = .fillProportionally
            
            cancelAndConfirmButtonStack.topAnchor.constraint(equalTo: topToAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            cancelAndConfirmButtonStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
            cancelAndConfirmButtonStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
            cancelAndConfirmButtonStack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                .isActive = true
        }
        
        if let titleAndMessageStack = titleAndMessageStack {
            titleAndMessageStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleAndMessageStack)
            titleAndMessageStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            titleAndMessageStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -AutoLayoutConstants.padding * 2)
                .isActive = true
            titleAndMessageStack.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor)
                .isActive = true
            loadCancelAndConfirmButtonStack(under: titleAndMessageStack.bottomAnchor)
        } else {
            loadCancelAndConfirmButtonStack(under: topAnchor)
        }
    }
    
    private func loadProgressView(_ progressView: UIView) {
        func loadProgressIndicator() {
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            progressView.widthAnchor.constraint(equalToConstant: AutoLayoutConstants.indicatorWidth)
                .isActive = true
            progressView.heightAnchor.constraint(equalToConstant: AutoLayoutConstants.indicatorWidth)
                .isActive = true
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
        }
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        loadProgressIndicator()
        
        if let titleAndMessageStack = titleAndMessageStack {
            progressView.removeConstraints(progressView.constraints)
            progressView.widthAnchor.constraint(equalToConstant: AutoLayoutConstants.indicatorWidth)
                .isActive = true
            progressView.heightAnchor.constraint(equalToConstant: AutoLayoutConstants.indicatorWidth)
                .isActive = true
            titleAndMessageStack.alignment = .leading
            
            let indicatorAndTextStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [progressView, titleAndMessageStack])
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.alignment = .center
                stack.axis = .horizontal
                stack.distribution = .equalSpacing
                stack.spacing = AutoLayoutConstants.padding
                return stack
            }()
            
            addSubview(indicatorAndTextStack)
            indicatorAndTextStack.topAnchor.constraint(equalTo: topAnchor, constant: AutoLayoutConstants.padding)
                .isActive = true
            indicatorAndTextStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AutoLayoutConstants.padding)
                .isActive = true
            indicatorAndTextStack.centerXAnchor.constraint(equalTo: centerXAnchor)
                .isActive = true
            indicatorAndTextStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -AutoLayoutConstants.padding * 3 - AutoLayoutConstants.indicatorWidth)
                .isActive = true
        }
    }
    
    private var titleAndMessageStack: UIStackView? {
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .equalSpacing
            stack.spacing = AutoLayoutConstants.padding
            return stack
        }()
        
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
    
    @objc private func confirmButtonTapped(sender button: UIButton) {
        delegate?.alertView(self, didTapConfirmButton: button)
    }
}
