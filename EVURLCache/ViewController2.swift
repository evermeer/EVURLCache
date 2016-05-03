//
//  ViewController2.swift
//  EVURLCache
//
//  Created by Basem Emara on 5/3/16.
//  Copyright © 2016 evict. All rights reserved.
//

import UIKit
import WebKit

class ViewController2: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create preferences on how the web page should be loaded
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        if let url = NSURL(string: "http://evict.nl") {
            NSLog("navigating to \(url)")
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the network activity indicator when the web view is loading
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
  
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        // Stop the network activity indicator when the loading finishes
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //self.navigationController?.finishProgress()
    }
  
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow)
    }

}