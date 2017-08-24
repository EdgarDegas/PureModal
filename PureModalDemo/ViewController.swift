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
    
    let alertController = PureAlertController(withTitle: "Title", message: "message", withStyle: .default(buttonTitle: nil))
    
    @IBAction func presentAlertButtonTapped(_ sender: UIButton) {
        alertController.delegate = self
        alertController.alertTitle = "Changed Title"
        alertController.title = "Changed Title with Title"
        alertController.modal(animated: true, for: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: PureAlertControllerDelegate {
    func alertView(_ alertView: PureAlertView, in controller: PureAlertController, didTapCancelButton cancelButton: UIButton) {
        controller.dismiss(animated: true, completion: nil)
    }
}
