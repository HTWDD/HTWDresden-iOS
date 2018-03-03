//
//  ModalPopTransition.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

protocol AnimatedViewControllerTransitionDataSource: class {
    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView?
}

extension AnimatedViewControllerTransitionDataSource {
    func viewForTransition(_ transition: AnimatedViewControllerTransition) -> UIView? {
        return nil
    }
}

protocol AnimatedViewControllerTransitionAnimator: class {
    func animate(source: CGRect, sourceView: UIView?, duration: TimeInterval, direction: Direction, completion: @escaping (Bool) -> Void)
}

enum Direction {
    case present, dismiss
}

class AnimatedViewControllerTransition: NSObject {

    let duration: TimeInterval
    fileprivate weak var back: AnimatedViewControllerTransitionDataSource?
    fileprivate weak var front: AnimatedViewControllerTransitionAnimator?

    fileprivate var direction = Direction.present

    init?(duration: TimeInterval, back: UIViewController, front: UIViewController) {
        _ = front.view

        self.duration = duration

        guard
            let back = back as? AnimatedViewControllerTransitionDataSource,
            let front = front as? AnimatedViewControllerTransitionAnimator
        else {
            return nil
        }

        self.back = back
        self.front = front
    }

}

extension AnimatedViewControllerTransition: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.direction = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.direction = .dismiss
        return self
    }

}

extension AnimatedViewControllerTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated ?? false ? self.duration : 0.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        var cancelled = false

        defer {
            if cancelled {
                transitionContext.completeTransition(false)
            }
        }

        guard let views = transitionContext.views else {
            cancelled = true
            return
        }

        if self.direction == .present {
            views.container.add(views.destination)
        }

        views.destination.frame = views.container.bounds

        let duration = self.transitionDuration(using: transitionContext)

        let sourceView = self.back?.viewForTransition(self)

        let rect = sourceView.map { $0.convert($0.bounds, to: views.container) } ?? CGRect.zero

        self.front?.animate(source: rect, sourceView: sourceView, duration: duration, direction: self.direction, completion: { fininshed in
            transitionContext.completeTransition(fininshed)
        })
    }
}

fileprivate extension UIViewControllerContextTransitioning {

    var views: (destination: UIView, container: UIView)? {
        guard let destination = self.view(forKey: .to) ?? self.view(forKey: .from) else {
            return nil
        }
        return (destination, self.containerView)
    }

}
