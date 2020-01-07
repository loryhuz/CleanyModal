//
//  CleanyModalTransitionDelegates.swift
//  CleanyModal
//
//  Created by Lory Huz on 22/03/2018.
//

import UIKit

public class CleanyModalTransition: NSObject, UIViewControllerTransitioningDelegate {
    public var interactor: CleanyModalTransitionInteractor
    
    public override init() {
        interactor = CleanyModalTransitionInteractor()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CleanyModalPresenter()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CleanyModalDismisser()
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

protocol CleanyModalTransitionInteractorDelegate {
    func hasCancelledTransition()
    func hasFinishedTransition()
}

open class CleanyModalTransitionInteractor: UIPercentDrivenInteractiveTransition {
    open var hasStarted = false
    open var shouldFinish = false
    
    var delegate: CleanyModalTransitionInteractorDelegate?
    
    open override func cancel() {
        super.cancel()
        
        self.delegate?.hasCancelledTransition()
    }
    
    open override func finish() {
        super.finish()
        
        self.delegate?.hasFinishedTransition()
    }
}

public class CleanyModalDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var animatorForCurrentSession: UIViewImplicitlyAnimating?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    @available(iOS 10.0, *)
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animatorForCurrentSession = self.animatorForCurrentSession {
            return animatorForCurrentSession
        }
        
        guard let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CleanyModalViewController,
            let targetViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                preconditionFailure("controller should inherit from CleanyModalViewController class")
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(targetViewController.view, belowSubview: sourceViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        let animator = transitionContext.isInteractive ?
            UIViewPropertyAnimator(duration: duration, dampingRatio: 100) :
            UIViewPropertyAnimator(duration: duration, timingParameters: UICubicTimingParameters(controlPoint1: CGPoint(x: 1, y: 0), controlPoint2: CGPoint(x: 0, y: 1)))
        
        if let actionSheet = sourceViewController as? CleanyAlertViewController, actionSheet.preferredStyle == .actionSheet {
            sourceViewController.alertViewCenterY.constant += sourceViewController.alertView.center.y + (sourceViewController.alertView.frame.height / 2)
        } else {
            sourceViewController.alertViewCenterY.constant += sourceViewController.alertView.center.y + (sourceViewController.alertView.frame.height / 2)
        }
        

        animator.addAnimations {
            sourceViewController.view.layoutIfNeeded()
            sourceViewController.view.backgroundColor = UIColor.clear
        }
        
        animator.addCompletion { position in
            self.animatorForCurrentSession = nil
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                UIApplication.shared.keyWindow?.addSubview(targetViewController.view)
            }
        }
        
        animatorForCurrentSession = animator
        return animator
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard #available(iOS 10.0, *) else {
            obsoletedAnimateTransition(using: transitionContext)
            return
        }
        
        let anim = self.interruptibleAnimator(using: transitionContext)
        anim.startAnimation()
    }
    
    private func obsoletedAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CleanyModalViewController,
            let targetViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                preconditionFailure("controller should inherit from CleanyModalViewController class")
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(targetViewController.view, belowSubview: sourceViewController.view)
        
        sourceViewController.alertViewCenterY.constant += sourceViewController.alertView.center.y + (sourceViewController.alertView.frame.height / 2)
        
        let timingFunction = transitionContext.isInteractive ?
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) :
            CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(transitionDuration(using: transitionContext))
        CATransaction.setAnimationTimingFunction(timingFunction)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                sourceViewController.view.layoutIfNeeded()
                sourceViewController.view.backgroundColor = UIColor.clear
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                UIApplication.shared.keyWindow?.addSubview(targetViewController.view)
            }
        }
        CATransaction.commit()
    }
}

public class CleanyModalPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    private func animation(for keyPath: String, value: Any) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.toValue = value
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        return animation
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let targetViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? CleanyModalViewController else {
                preconditionFailure("controller should inherit from CleanyModalViewController class")
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(targetViewController.view, belowSubview: sourceViewController.view)
        
        let endBottomConstraintValue = targetViewController.alertViewBottom?.constant ?? 0
        let endCenterYConstraintValue = targetViewController.alertViewCenterY.constant
        
        // Start value => out-of-screen
        targetViewController.alertViewCenterY.constant += targetViewController.alertView.center.y + (targetViewController.alertView.frame.height / 2)
        targetViewController.alertViewBottom?.constant -= targetViewController.alertView.frame.height
        // Apply
        targetViewController.view.layoutIfNeeded()
        // End value to animate => center of screen
        targetViewController.alertViewCenterY.constant = endCenterYConstraintValue
        targetViewController.alertViewBottom?.constant = endBottomConstraintValue
        
        targetViewController.view.alpha = 0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(transitionDuration(using: transitionContext))
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 1, 0, 0, 1))
        CATransaction.setCompletionBlock {
            // Ensure layout is doing well
            targetViewController.alertViewCenterY.constant = endCenterYConstraintValue
            targetViewController.alertViewBottom?.constant = endBottomConstraintValue
            targetViewController.view.layoutIfNeeded()

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                UIApplication.shared.keyWindow?.addSubview(targetViewController.view)
            }
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            targetViewController.view.alpha = 1
            targetViewController.view.layoutIfNeeded()
        }

        CATransaction.commit()
    }
}
