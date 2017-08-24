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
    
    
    @IBAction func presentAlertButtonTapped(_ sender: UIButton) {
        let alertController = PureAlertController()
        alertController.delegate = self
        alertController.modal(for: self)
//        present(alertC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        alertC.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
//            self.alertC.dismiss(animated: true, completion: nil)
//        }))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton) {
        controller.dismiss(animated: false, completion: nil)
    }
}
