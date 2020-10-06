//
//  CleanyModalViewController.swift
//  CleanyModal
//
//  Created by Lory Huz on 20/03/2018.
//

import UIKit

open class CleanyModalViewController: UIViewController {
    
    open var modalTransition = CleanyModalTransition() {
        didSet {
            transitioningDelegate = modalTransition
        }
    }
    open var onDismissCallback: ((UIViewController) -> ())?
    
    @IBOutlet public var alertView: UIView!
    @IBOutlet public var alertViewCenterY: NSLayoutConstraint!
    @IBOutlet public var alertWidthConstraint: NSLayoutConstraint!
    @IBOutlet public var alertViewBottom: NSLayoutConstraint?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = modalTransition
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Actually custom transition doesn't work if you present an Alert in a modal controller with pageSheet style, need help on this :) Fallback on default transition then
        if #available(iOS 13.0, *) {
            transitioningDelegate = nil
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Handle Keyboard/TextField notifification
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            guard let globalPoint = alertView.superview?.convert(alertView.frame.origin, to: nil) else { return }
            
            if (endFrame?.origin.y)! >= globalPoint.y + alertView.frame.size.height {
                alertViewCenterY.constant = 0
            } else {
                if endFrame?.size.height != nil {
                    let y = view.frame.size.height - (globalPoint.y + alertView.frame.size.height)
                    let offset = endFrame!.size.height - y
                    alertViewCenterY.constant -= offset + 20
                } else {
                    alertViewCenterY.constant = 0
                }
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

