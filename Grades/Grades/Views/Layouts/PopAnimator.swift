//
//  PopAnimator.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 2.0
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let detailView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            detailView.clipsToBounds = true
        }
        
        detailView.layer.cornerRadius = presenting ? 20.0 : 0.0
        detailView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)
        
        UIView.animate(withDuration: duration, animations: {
            detailView.transform = self.presenting ? .identity : scaleTransform
            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            detailView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }) { _ in
            transitionContext.completeTransition(true)
        }
        
    }
    
}
