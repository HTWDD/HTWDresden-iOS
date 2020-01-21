//
//  MFMailComposeViewController.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 15.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import MessageUI

extension MFMailComposeViewController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
