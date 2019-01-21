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
        let alertData = CleanyModalBasicData(
            title: "Hello world",
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed massa a magna semper semper a eget justo",
            iconImgName: "warning_icon")
        let alert = MyAlertViewController(data: alertData)
        
        alert.addAction(CleanyAlertAction(title: "OK", style: .default))
        alert.addAction(CleanyAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showTextfieldAlertAction(_ sender: UIButton) {        
        let alertData = CleanyModalBasicData(
            title: "Password forgotten ?",
            message: "We'll regenerate your password and send the new one in your mail inbox",
            iconImgName: nil)
        let alert = MyAlertViewController(data: alertData)
        alert.addTextField { textField in
            textField.placeholder = "Enter your e-mail"
            textField.font = UIFont.systemFont(ofSize: 12)
            textField.autocorrectionType = .no
            textField.keyboardType = .emailAddress
        }
        
        alert.addAction(CleanyAlertAction(title: "Send new password", style: .default, handler: { action in
            print("email in textfield is: \(alert.textFields?.first?.text ?? "empty")")
        }))
        alert.addAction(CleanyAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
}

class MyAlertViewController: CleanyAlertViewController {
    override init(data: CleanyModalBasicData, style: CleanyModalStyle? = nil) {
        if style == nil {
            let defaultStyle = CleanyModalStyle(
                tintColor: UIColor(red: 8/255, green: 61/255, blue: 119/255, alpha: 1),
                destructiveColor: UIColor(red: 218/255, green: 65/255, blue: 103/255, alpha: 1)
            )
            super.init(data: data, style: defaultStyle)
        } else {
            super.init(data: data, style: style)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
