//
//  LeftToRightTransition.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 08/03/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class SlideTransition: NSObject, UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate {
    
    let duration = 0.4
    enum AnimationTransitionMode: Int {
        case Present,Dismiss
    }
    
    var transitionMode: AnimationTransitionMode = .Present
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        
        let screenOffRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let screenOffLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
//        container.addSubview(fromView)
        
        switch transitionMode {
        case .Present:
            container.addSubview(toView)
            toView.transform = screenOffRight
            
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
                fromView.transform = screenOffLeft
            }) { (success) in
                transitionContext.completeTransition(success)
            }
        case .Dismiss:
            container.addSubview(toView)
            toView.transform = screenOffLeft
            
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
                fromView.transform = screenOffRight
            }) { (success) in
                transitionContext.completeTransition(success)
            }
        }
        

    }
    
    

}
