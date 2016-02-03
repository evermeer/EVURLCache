//
//  ViewController.swift
//  EVURLCache
//
//  Created by Edwin Vermeer on 11/7/15.
//  Copyright © 2015 evict. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Uncomment the 2 lines below and comment the line below that to see an other nice test
//        EVURLCache.RECREATE_CACHE_RESPONSE = false
//        if let url = NSURL(string: "http://game.zorropk.com/gamenow/xiao5haiyanglixianji/") {
        if let url = NSURL(string: "http://evict.nl") {
            NSLog("navigating to \(url)")
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

