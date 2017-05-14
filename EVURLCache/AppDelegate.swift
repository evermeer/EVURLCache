//
//  AppDelegate.swift
//  EVURLCache
//
//  Created by Edwin Vermeer on 11/7/15.
//  Copyright © 2015 evict. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // We want to see all caching actions
        EVURLCache.LOGGING = true
        // We want more than the default: 2^26 = 64MB
        EVURLCache.MAX_FILE_SIZE = 26
        // We want more than the default: 2^30 = 1GB
        EVURLCache.MAX_CACHE_SIZE = 30
        // Use this to force case insensitive filename compare when using a case sensitive filesystem (what OS X can have)
        EVURLCache.FORCE_LOWERCASE = true // is already the default. You also have to put all files int he PreCache using lowercase names
        // By default cache control settings that come from the server will not be ignored. Here for testing we always ignore it.
        EVURLCache.IGNORE_CACHE_CONTROL = true
        
        // You can create your own filtering to prevent using the cache for specific files
        EVURLCache.filter { request in
            if request.url?.host == "githubbadge.appspot.com" {
                return false
            }
            return true
        }
                
        // Now activate this cache
        EVURLCache.activate()
        NSLog("Cache is now active")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

