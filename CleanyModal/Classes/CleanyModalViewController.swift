//
//  CleanyModalViewController.swift
//  CleanyModal
//
//  Created by Lory Huz on 20/03/2018.
//

import UIKit

open class CleanyModalViewController: UIViewController {
    
    open var transitionInteractor: CleanyModalTransitionInteractor? = nil
    open var onDismissCallback: ((UIViewController) -> ())?
    
    @IBOutlet public var alertView: UIView!
    @IBOutlet public var alertViewCenterY: NSLayoutConstraint!
    @IBOutlet public var widthConstraint: NSLayoutConstraint!

    private var gestureRecognizer: UIPanGestureRecognizer!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: .handleGesture)
        alertView.addGestureRecognizer(gestureRecognizer)
        
        transitionInteractor?.delegate = self
        
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

        let percentThreshold: CGFloat = 0.15

        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: self.view)
        let verticalMovement = translation.y / self.view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = transitionInteractor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            onDismissCallback?(self)
            dismiss(animated: true, completion: nil)
            // glitch fix https://stackoverflow.com/questions/48666523/glitch-when-interactively-dismiss-a-modal-view-controller/50238562#50238562
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                interactor.update(progress)
            }
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
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
