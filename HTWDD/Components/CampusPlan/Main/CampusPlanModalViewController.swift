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
        }
        
    }
 
    // MARK: - User Interaction
    @IBAction func onDismissTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
