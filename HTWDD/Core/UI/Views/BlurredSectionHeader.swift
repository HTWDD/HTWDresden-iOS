//
//  BlurredSectionHeade.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 19.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

class BlurredSectionHeader: UIView {
    
    // MARK: - Config
    private enum Constant {
        static let topSpace: CGFloat        = 8
        static let leadingSpace: CGFloat    = 10
    }
    
    // MARK: - Blurred View
    private lazy var wrapper: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 60)).also { wrapperView in
            wrapperView.addSubview(UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).also { effectView in
                effectView.frame = wrapperView.bounds
            })
        }
    }()
    
    // MARK: - Header & SubHeader
    private lazy var header: UILabel = {
        return UILabel().also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor    = UIColor.htw.darkGrey
            $0.font         = UIFont.from(style: .big)
        }
    }()
    
    private lazy var subHeader: UILabel = {
        return UILabel().also {
            $0.textColor    = UIColor.htw.grey
            $0.font         = UIFont.from(style: .small)
        }
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, header: String, subHeader: String) {
        super.init(frame: frame)
        self.header.text    = header
        self.subHeader.text = subHeader
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        let vStack = UIStackView(arrangedSubviews: [header, subHeader]).also {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis         = .vertical
            $0.distribution = .fill
            $0.spacing      = 2
        }
        wrapper.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: Constant.leadingSpace),
            vStack.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: Constant.topSpace)
            ])
        
        addSubview(wrapper)
    }
}
