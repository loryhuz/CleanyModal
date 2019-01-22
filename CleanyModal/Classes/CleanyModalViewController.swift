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
    @IBOutlet public var widthConstraint: NSLayoutConstraint!

    private var gestureRecognizer: UIPanGestureRecognizer!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: .handleGesture)
        alertView.addGestureRecognizer(gestureRecognizer)
        
        modalTransition.interactor.delegate = self
        transitioningDelegate = modalTransition
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction open func handleGesture(_ sender: UIPanGestureRecognizer) {

        let percentThreshold: CGFloat = 0.10
      
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let verticalMovement = translation.y / self.view.bounds.height
        let progress = min(max(verticalMovement, 0.0), 1.0)
        let interactor = modalTransition.interactor
        
        switch sender.state {
        case .began, .changed:
            if velocity.y > 0 && interactor.hasStarted == false {
                interactor.hasStarted = true
                dismiss(animated: true, completion: nil)
            }
            interactor.shouldFinish = (progress > percentThreshold) && velocity.y > 0
            interactor.update(progress)
            interactor.completionSpeed = 1.0 - interactor.percentComplete
        default:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        }
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

// MARK: - Selectors

fileprivate extension Selector {
    static let handleGesture = #selector(CleanyModalViewController.handleGesture(_:))
}

extension CleanyModalViewController: CleanyModalTransitionInteractorDelegate {
    func hasFinishedTransition() {}
    
    func hasCancelledTransition() {
        // Ensure auto-layout is doing well
        self.alertViewCenterY.constant = 0
        self.view.layoutIfNeeded()
    }
}
