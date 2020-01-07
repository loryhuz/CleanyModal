//
//  ViewController.swift
//  CleanyModal
//
//  Created by loryhuz on 03/20/2018.
//  Copyright (c) 2018 loryhuz. All rights reserved.

import UIKit
import CleanyModal

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        guard let stackView = view.subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
        stackView.subviews.forEach { subview in
            subview.layer.cornerRadius = subview.frame.height / 2
            subview.clipsToBounds = true
        }
    }
    
    @IBAction func showBasicAlertAction(_ sender: UIButton) {
        let alert = MyAlertViewController(
            title: "Hello world",
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo",
            imageName: "warning_icon")

        alert.addAction(title: "OK", style: .default)
        alert.addAction(title: "Cancel", style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showTextfieldAlertAction(_ sender: UIButton) {
        let alert = MyAlertViewController(
            title: "Password forgotten ?",
            message: "We'll regenerate your password and send the new one in your mail inbox")
        
        alert.addTextField { textField in
            textField.placeholder = "Enter your e-mail"
            textField.font = UIFont.systemFont(ofSize: 12)
            textField.autocorrectionType = .no
            textField.keyboardType = .emailAddress
            textField.keyboardAppearance = .dark
        }
        
        alert.addAction(title: "Send new password", style: .default, handler: { action in
            print("email in textfield is: \(alert.textFields?.first?.text ?? "empty")")
        })
        alert.addAction(title: "Cancel", style: .cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetAction(_ sender: UIButton) {
        let alert = MyAlertViewController(
            title: "Alert with action sheet style",
            message: "Choose your action",
            preferredStyle: .actionSheet)
        
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(title: "Save", style: .default)
        alert.addAction(title: "Remove", style: .destructive)
        
        present(alert, animated: true, completion: nil)
    }
}

// *** Example to have a default style settings for your alerts in your project
// *** Subclass CleanyAlertViewController, and get a custom init where you set your style config
//
class MyAlertViewController: CleanyAlertViewController {
    
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.cornerRadius] = 18
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
