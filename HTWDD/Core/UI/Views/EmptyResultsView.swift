//
//  EmptyResultsView.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 18.09.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class EmptyResultsView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let horizontalMargin: CGFloat    = 20
        static let minVerticalMargin: CGFloat   = 30
    }
    
    // MARK: - Configuration
    struct Configuration {
        let icon: String?
        let title: String
        let message: String
        let hint: String?
        let action: UIGestureRecognizer?
    }
    
    // MARK: - Properties
    private var mutableViews = [UIView]()
    
    private let icon: UILabel = {
        return UILabel().also {
            $0.font             = UIFont.from(style: .big)
            $0.textColor        = UIColor.htw.Label.primary
            $0.textAlignment    = .center
            $0.numberOfLines    = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }()
    
    private let title: UILabel = {
        return UILabel().also {
            $0.font             = UIFont.from(style: .big)
            $0.textColor        = UIColor.htw.Label.primary
            $0.textAlignment    = .center
            $0.numberOfLines    = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }()
    
    private let message: UILabel = {
        return UILabel().also {
            $0.font             = UIFont.from(style: .description)
            $0.textColor        = UIColor.htw.Label.secondary
            $0.textAlignment    = .center
            $0.numberOfLines    = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }()
    
    private let hint: UIButton = {
        return UIButton().also {
            $0.titleLabel?.font     = UIFont.from(style: .small, isBold: true)
            $0.layer.cornerRadius   = 4
            $0.backgroundColor      = UIColor.htw.lightBlueMaterial
            $0.contentEdgeInsets    = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            $0.makeDropShadow()
            $0.setTitleColor(.white, for: .normal)
        }
    }()
        
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    func setup(with configuration: Configuration) {
        subviews.forEach { v in
            v.removeFromSuperview()
        }
        mutableViews.removeAll()
        
        icon.text = configuration.icon
        title.text = configuration.title
        message.text = configuration.message
        hint.setTitle(configuration.hint, for: .normal)
        
        if let _ = configuration.icon {
            mutableViews.append(icon)
        }
        mutableViews.append(title)
        mutableViews.append(message)
        
        if let _ = configuration.hint, let action = configuration.action {
            hint.addGestureRecognizer(action)
            mutableViews.append(hint)
        }
        
        isHidden = false
        setup()
    }
    
    private func setup() {
        
        
        let vStack = UIStackView(arrangedSubviews: mutableViews)
        vStack.apply {
            $0.alignment    = .center
            $0.axis         = .vertical
            $0.spacing      = 10
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        add(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalMargin),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalMargin),
            vStack.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -Constants.minVerticalMargin * 2)
        ])
    }
}
