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
//        let alertConfig = CleanyAlertConfig(
//            title: "Hello world",
//            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo",
//            iconImgName: "warning_icon")
        let alert = MyAlertViewController(
            title: "Hello world",
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo")

        alert.addAction(title: "OK", style: .default)
        alert.addAction(title: "Cancel", style: .cancel)
        
//        let alert = UIAlertController(title: "Hello world", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo", preferredStyle: UIAlertController.Style.alert)
//        
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
