//
//  NativeModalViewController.swift
//  CleanyModal_Example
//
//  Created by Lory Huz on 30/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CleanyModal

class NativeModalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showAlert(_ sender: Any) {
        let alert = MyAlertViewController(
            title: "Hello world",
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo")

        alert.addAction(title: "OK", style: .default)
        alert.addAction(title: "Cancel", style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}
