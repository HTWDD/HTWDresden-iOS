//
//  UIViewContorller.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 20/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

private var transitionKey: UInt8 = 0
fileprivate var vSpinner : UIView?

extension UIViewController {
    
    var transition: UIViewControllerTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(self, &transitionKey) as? UIViewControllerTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(self, &transitionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.transitioningDelegate = newValue
        }
    }

    func inNavigationController() -> NavigationController {
        if let n = self.navigationController as? NavigationController {
            return n
        }
        return NavigationController(rootViewController: self)
    }

    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoadingIndicator(on view: UIView) {
        let backgroundView = UIView(frame: view.bounds).also { bView in
            bView.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .regular)).also(block: { effect in
                effect.frame = bView.bounds
            }))
            
            bView.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80)).also {
                $0.dropShadow()
                $0.backgroundColor      = UIColor.htw.cellBackground
                $0.layer.cornerRadius   = 4
                $0.center               = bView.center
            })
            
            let vStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 50)).also {
                $0.axis         = .vertical
                $0.alignment    = .center
                $0.center       = bView.center
                $0.spacing      = 10
            }
            
            vStack.addArrangedSubview(UILabel().also {
                $0.text         = R.string.localizable.loading()
                $0.textColor    = UIColor.htw.Label.primary
                $0.font         = UIFont.htw.Labels.primary
                $0.center       = bView.center
            })
            
            let style: UIActivityIndicatorView.Style
            if #available(iOS 12.0, *) {
                if traitCollection.userInterfaceStyle == .dark {
                    style = .white
                } else {
                    style = .gray
                }
            } else {
                style = .gray
            }
            
            vStack.addArrangedSubview(UIActivityIndicatorView(style: style).also {
                $0.startAnimating()
                $0.center = bView.center
            })
            
            bView.addSubview(vStack)
        }
        
        DispatchQueue.main.async {
            view.addSubview(backgroundView)
        }
        
        vSpinner = backgroundView
    }
    
    func removeLoadingIndicator() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
