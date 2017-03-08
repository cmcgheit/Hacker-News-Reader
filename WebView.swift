//
//  WebView.swift
//  HackerNewsReader
//
//  Created by C McGhee on 3/4/17.
//  Copyright © 2017 Carey McGhee. All rights reserved.
//

import UIKit

class WebView: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        webview.loadRequest(URLRequest(url: URL(string: url!)!))
    }

}
