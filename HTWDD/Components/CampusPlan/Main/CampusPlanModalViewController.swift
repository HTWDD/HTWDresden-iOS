//
//  CampusPlanModalViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 13.01.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import Foundation
import ImageScrollView

class CampusPlanModalViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    // MARK: - Properties
    var image: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            imageScrollView.display(image: image)
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDraging(_:))))
        }
    }
 
    // MARK: - User Interaction
    @IBAction func onDismissTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onDraging(_ sender:UIPanGestureRecognizer) {
        let newY        = ensureRange(value: view.frame.minY + sender.translation(in: view).y, minimum: 0, maximum: view.frame.maxY)
        let progress    = progressAlongAxis(newY, view.bounds.height)

        view.frame.origin.y = newY

        if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y >= 300 || progress > 0.3 {
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame.origin.y = 0
                })
            }
       }
       sender.setTranslation(.zero, in: view)
    }
    
    // MARK: - Helpers
    private func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }

    private func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
        return min(max(value, minimum), maximum)
    }
}
