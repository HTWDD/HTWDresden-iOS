//
//  WebViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 11.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit

class WKWebViewController: UIViewController {
    
    // MARK: - Properties
    private var filename: String?
    private var url: URL?
    
    private lazy var wkWebView: WKWebView = {
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        return WKWebView(frame: .zero, configuration: WKWebViewConfiguration().also { configuration in
            configuration.userContentController = WKUserContentController().also { controller in
                controller.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
            }
        })
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func show(title: String, filename: String) {
        self.title      = title
        self.filename   = filename
    }
    
    func show(title: String, url: URL) {
        self.title  = title
        self.url    = url
    }
}

// MARK: - Setup
extension WKWebViewController {
    
    private func setup() {
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        view.apply { v in
            v.backgroundColor = UIColor.htw.veryLightGrey
            v.add(wkWebView.also { wkV in
                wkV.frame = v.frame
            })
        }
        
        if let filename = filename {
            guard let path = Bundle.main.path(forResource: filename, ofType: nil) else { return }
            do {
                wkWebView.loadHTMLString(try String(contentsOfFile: path), baseURL: nil)
            } catch let error {
                Log.error(error)
            }
        }
        
        if let url = url {
            wkWebView.load(URLRequest(url: url))
        }
        
    }
    
}
