//
//  UIView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 01.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

extension UIView {

    var width: CGFloat {
        get { return self.bounds.size.width }
        set { self.bounds.size.width = newValue }
    }

    var height: CGFloat {
        get { return self.bounds.size.height }
        set { self.bounds.size.height = newValue }
    }

    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }

    var bottom: CGFloat {
        get { return self.top + self.height }
        set { self.top = newValue - self.height }
    }

    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }

    var right: CGFloat {
        get { return self.left + self.width }
        set { self.left = newValue - self.width }
    }
    
    func add(_ views: UIView..., transform: ((UIView) -> Void)? = nil) {
        views.forEach {
            self.addSubview($0)
            transform?($0)
        }
    }
    
    func layoutMatchingEdges(_ view: UIView?) {
        guard let view = view else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.topAnchor.constraint(equalTo: self.htw.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension HTWNamespace where Base: UIView {
	var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.base.safeAreaInsets
        }
        return .zero
	}
    var safeAreaLayoutGuide: LayoutGuide {
        if #available(iOS 11.0, *) {
            return self.base.safeAreaLayoutGuide
        }
        return self.base
    }
}

// MARK: - Confetti
extension UIView {
	// https://github.com/sudeepag/SAConfettiView
	/// Emits confetti over the entire view for the given duration.
	func emitConfetti(duration: Double) {
		let colors = [UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
					  UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
					  UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
					  UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
					  UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)]
		let emitter = CAEmitterLayer()
		
		emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
		emitter.emitterShape = CAEmitterLayerEmitterShape.line
		emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
		emitter.beginTime = CACurrentMediaTime()
		
		var cells = [CAEmitterCell]()
		for color in colors {
			cells.append(confettiWithColor(color: color))
		}
		
		emitter.emitterCells = cells
		layer.addSublayer(emitter)
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
			emitter.birthRate = 0
		}
	}
}

fileprivate func confettiWithColor(color: UIColor, intensity: CGFloat = 0.5) -> CAEmitterCell {
	let image = UIImage(named: "confetti.png")
	
	let confetti = CAEmitterCell()
	confetti.birthRate = Float(CGFloat(6.0 * intensity))
	confetti.lifetime = Float(CGFloat(14.0 * intensity))
	confetti.lifetimeRange = 0
	confetti.color = color.cgColor
	confetti.velocity = CGFloat(350.0 * intensity)
	confetti.velocityRange = CGFloat(80.0 * intensity)
	confetti.emissionLongitude = CGFloat(Double.pi)
	confetti.emissionRange = CGFloat((Double.pi / 4))
	confetti.spin = CGFloat(3.5 * intensity)
	confetti.spinRange = CGFloat(4.0 * intensity)
	confetti.scaleRange = CGFloat(intensity)
	confetti.scaleSpeed = CGFloat(-0.1 * intensity)
	confetti.contents = image?.cgImage
	
	return confetti
}


// MARK: - Dropshadow
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.apply {
            $0.masksToBounds        = false
            $0.shadowColor          = UIColor.htw.shadow.cgColor
            $0.shadowOpacity        = 0.35
            $0.shadowOffset         = .zero
            $0.shadowRadius         = 3
            $0.shouldRasterize      = true
            $0.rasterizationScale   = scale ? UIScreen.main.scale : 1
        }
    }
    
    func removeDropShdow() {
        layer.shadowRadius = 0
    }
    
    @IBInspectable var hasDropShadow: Bool {
        get { return layer.shadowRadius > 0 }
        set {
            if newValue {
                dropShadow()
            } else {
                removeDropShdow()
            }
        }
    }
}

// MARK: - CA Layers
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
     
}
