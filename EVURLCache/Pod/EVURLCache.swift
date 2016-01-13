//
//  EVURLCache.swift
//  EVURLCache
//
//  Created by Edwin Vermeer on 11/7/15.
//  Copyright © 2015 evict. All rights reserved.
//

import Foundation
import ReachabilitySwift

#if os(iOS)
    import MobileCoreServices
#elseif os(OSX)
    import CoreServices
#endif

public class EVURLCache : NSURLCache {
    
    public static var URLCACHE_CACHE_KEY = "MobileAppCacheKey" // Add this header variable to the response if you want to save the response using this key as the filename.
    public static var URLCACHE_EXPIRATION_AGE_KEY = "MobileAppExpirationAgeKey" // Add this header variable to the response to set the expiration age.
    public static var MAX_AGE = "604800000" // The default maximum age of a cached file in miliseconds. (1 week)
    public static var PRE_CACHE_FOLDER = "PreCache"  // The folder in your app with the prefilled cache content
    public static var CACHE_FOLDER = "Cache" // The folder in the Documents folder where cached files will be saved
    public static var MAX_FILE_SIZE = 24 // The maximum file size that will be cached (2^24 = 16MB)
    public static var MAX_CACHE_SIZE = 30 // The maximum file size that will be cached (2^30 = 256MB)
    public static var LOGGING = false // Set this to true to see all caching action in the output log
    public static var FORCE_LOWERCASE = true // Set this to false if you want to use case insensitive filename compare
    public static var _cacheDirectory: String!
    public static var _preCacheDirectory: String!

    // Activate EVURLCache
    public class func activate() {
        // set caching paths
        _cacheDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]).URLByAppendingPathComponent(CACHE_FOLDER).absoluteString
        _preCacheDirectory = NSURL(fileURLWithPath: NSBundle.mainBundle().resourcePath!).URLByAppendingPathComponent(PRE_CACHE_FOLDER).absoluteString
        
        let urlCache = EVURLCache(memoryCapacity: 1<<MAX_FILE_SIZE, diskCapacity: 1<<MAX_CACHE_SIZE, diskPath: _cacheDirectory)

        NSURLCache.setSharedURLCache(urlCache)
    }
    
    // Log a message with info if enabled
    public static func debugLog<T>(object: T, filename: String = __FILE__, line: Int = __LINE__, funcname: String = __FUNCTION__) {
        if LOGGING {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
            let process = NSProcessInfo.processInfo()
            let threadId = "." //NSThread.currentThread().threadDictionary
            NSLog("\(dateFormatter.stringFromDate(NSDate())) \(process.processName))[\(process.processIdentifier):\(threadId)] \((filename as NSString).lastPathComponent)(\(line)) \(funcname):\r\t\(object)\n")
        }
    }
    
    // Will be called by a NSURLConnection when it's wants to know if there is something in the cache.
    public override func cachedResponseForRequest(request: NSURLRequest) -> NSCachedURLResponse? {
        guard let url = request.URL else {
            EVURLCache.debugLog("CACHE not allowed for nil URLs");
            return nil
        }
        
        if url.absoluteString.isEmpty {
            EVURLCache.debugLog("CACHE not allowed for empty URLs");
            return nil;
        }
        
        // is caching allowed
        if ((request.cachePolicy == NSURLRequestCachePolicy.ReloadIgnoringCacheData || url.absoluteString.hasPrefix("file:/") || url.absoluteString.hasPrefix("data:")) && EVURLCache.networkAvailable()) {
            EVURLCache.debugLog("CACHE not allowed for \(url)");
            return nil;
        }
        
        // Is the file in the cache? If not, is the file in the PreCache?
        var storagePath: String = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory)
        if !NSFileManager.defaultManager().fileExistsAtPath(storagePath) {
            storagePath  = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory)
            if !NSFileManager.defaultManager().fileExistsAtPath(storagePath) {
                EVURLCache.debugLog("CACHE not found \(storagePath)")
                return nil;
            }
        }
        
        // Check file status only if we have network, otherwise return it anyway.
        if EVURLCache.networkAvailable() {
            // Max cache age for request
            let maxAge:String = request.valueForHTTPHeaderField(EVURLCache.URLCACHE_EXPIRATION_AGE_KEY) ?? EVURLCache.MAX_AGE
            
            do {
                let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(storagePath)
                if let modDate:NSDate = attributes[NSFileModificationDate] as? NSDate {
                    // Test if the file is older than the max age
                    if let threshold: NSTimeInterval = Double(maxAge) {
                        let modificationTimeSinceNow:NSTimeInterval? = -modDate.timeIntervalSinceNow
                        if modificationTimeSinceNow > threshold {
                            EVURLCache.debugLog("CACHE item older than \(maxAge) maxAgeHours");
                            return nil
                        }
                    }
                }
            } catch {}
        }
        
        // Read object from file
        if let response = NSKeyedUnarchiver.unarchiveObjectWithFile(storagePath) as? NSCachedURLResponse {
            EVURLCache.debugLog("Returning cached data from \(storagePath)");
            return response
        }
        return nil
    }
        
    // Will be called by NSURLConnection when a request is complete.
    public override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forRequest request: NSURLRequest) {
        if let httpResponse = cachedResponse.response as? NSHTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                EVURLCache.debugLog("CACHE Do not cache error \(httpResponse.statusCode) page for : \(request.URL) \(httpResponse.debugDescription)");
                return
            }
        }
        
        // check if caching is allowed
        if request.cachePolicy == NSURLRequestCachePolicy.ReloadIgnoringCacheData {
            // If the file is in the PreCache folder, then we do want to save a copy in case we are without internet connection
            let storagePath: String = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory)
            if !NSFileManager.defaultManager().fileExistsAtPath(storagePath) {
                EVURLCache.debugLog("CACHE not storing file, it's not allowed by the cachePolicy : \(request.URL)")
                return
            }
            EVURLCache.debugLog("CACHE file in PreCache folder, overriding cachePolicy : \(request.URL)");
        }
        
        // create storrage folder
        let storagePath: String = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory)
        if var storageDirectory: String = NSURL(fileURLWithPath: "\(storagePath)").URLByDeletingLastPathComponent?.absoluteString.stringByRemovingPercentEncoding {
            do {
                if storageDirectory.hasPrefix("file:") {
                    storageDirectory = storageDirectory.substringFromIndex(storageDirectory.startIndex.advancedBy(5))
                }
                try NSFileManager.defaultManager().createDirectoryAtPath(storageDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                EVURLCache.debugLog("Error creating cache directory \(storageDirectory)");
               EVURLCache.debugLog("Error \(error.debugDescription)");
            }
        }
        
        // save file
        EVURLCache.debugLog("Writing data to \(storagePath)");
        if !NSKeyedArchiver.archiveRootObject(cachedResponse, toFile: storagePath) {
            EVURLCache.debugLog("Could not write file to cache");
        } else {
            EVURLCache.debugLog("CACHE save file to Cache  : \(storagePath)");
            // prevent iCloud backup
            if !EVURLCache.addSkipBackupAttributeToItemAtURL(NSURL(fileURLWithPath: storagePath)) {
                EVURLCache.debugLog("Could not set the do not backup attribute");
            }
        }
    }
    
    
    // return the path if the file for the request is in the PreCache or Cache.
    public static func storagePathForRequest(request: NSURLRequest) -> String? {
        var storagePath: String? = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory)
        if !NSFileManager.defaultManager().fileExistsAtPath(storagePath ?? "") {
            storagePath = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory)
        }
        if !NSFileManager.defaultManager().fileExistsAtPath(storagePath ?? "") {
            storagePath = nil
        }
        return storagePath;
    }

    // build up the complete storrage path for a request plus root folder.
    public static func storagePathForRequest(request: NSURLRequest, rootPath: String) -> String {        
        var localUrl: String!
        let host: String = request.URL?.host ?? "default"
        
        // The filename could be forced by the remote server. This could be used to force multiple url's to the same cache file
        if let cacheKey = request.valueForHTTPHeaderField(URLCACHE_CACHE_KEY) {
            localUrl = "\(host)/\(cacheKey)"
        } else {
            if let path = request.URL?.relativePath {
                localUrl = "\(host)\(path)"
            } else {
                NSLog("WARNING: Unable to get the path from the request: \(request)")
            }
        }
        
        // Without an extension it's treated as a folder and the file will be called index.html
        if let storageFile: String = localUrl.componentsSeparatedByString("/").last {
            if !storageFile.containsString(".")  {
                localUrl = "/\(localUrl)/index.html"
            }
        }

        // Force case insensitive compare (OSX filesystem can be case sensitive)
        if FORCE_LOWERCASE {
            localUrl = "\(rootPath)/\(localUrl.lowercaseString)"
        } else {
            localUrl = "\(rootPath)/\(localUrl)"
        }
        
        // Cleanup
        if localUrl.hasPrefix("file:") {
            localUrl = localUrl.substringFromIndex(localUrl.startIndex.advancedBy(5))
        }
        localUrl = localUrl.stringByReplacingOccurrencesOfString("//", withString: "/")
        localUrl = localUrl.stringByReplacingOccurrencesOfString("//", withString: "/")
        return localUrl
    }
    
    public static func addSkipBackupAttributeToItemAtURL(url: NSURL) -> Bool {
        do {
            try url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
            return true
        } catch _ as NSError {
            debugLog("ERROR: Could not set 'exclude from backup' attribute for file \(url.absoluteString)")
        }
        return false
    }
    
    // Check if we have a network connection
    private static func networkAvailable() -> Bool {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            return reachability.isReachable()
        } catch {
            debugLog("Unable to create Reachability")
            return false
        }
    }
}



