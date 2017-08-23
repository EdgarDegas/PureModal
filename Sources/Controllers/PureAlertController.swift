//
//  PureAlertController.swift
//  PureModal
//
//  Created by 孙一萌 on 2017/8/23.
//  Copyright © 2017年 iMoeNya. All rights reserved.
//

import UIKit

open class PureAlertController: UIViewController {
    
    // MARK: - Variables and Interface
    
    var window: UIWindow!
    var alertView: UIView!
    weak var viewController: UIViewController?
    
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
//        window.backgroundColor = UIColor(white: 0, alpha: 0.7)
        window.windowLevel = UIWindowLevelAlert
        window.makeKeyAndVisible()
        window.rootViewController = UIViewController()
        window.rootViewController?.view.frame = UIScreen.main.bounds
        window.rootViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
    
    private func loadAlertView() {
        alertView = UIView()
        window.addSubview(alertView)
        alertView.layer.cornerRadius = 12
        alertView.backgroundColor = UIColor.white
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.widthAnchor.constraint(equalTo: window.widthAnchor, constant: -120)
            .isActive = true
        alertView.heightAnchor.constraint(equalTo: window.heightAnchor, constant: -400)
            .isActive = true
        alertView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            .isActive = true
        alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            .isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
