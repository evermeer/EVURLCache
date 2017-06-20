//
//  EVURLCache.swift
//  EVURLCache
//
//  Created by Edwin Vermeer on 11/7/15.
//  Copyright © 2015 evict. All rights reserved.
//

import Foundation
//import ReachabilitySwift

#if os(iOS)
    import MobileCoreServices
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

#elseif os(OSX)
    import CoreServices
#endif

open class EVURLCache: URLCache {

    open static var URLCACHE_CACHE_KEY = "MobileAppCacheKey" // Add this header variable to the response if you want to save the response using this key as the filename.
    open static var MAX_AGE = "604800" // The default maximum age of a cached file in seconds. (1 week)
    open static var PRE_CACHE_FOLDER = "PreCache"  // The folder in your app with the prefilled cache content
    open static var CACHE_FOLDER = "Cache" // The folder in the Documents folder where cached files will be saved
    open static var MAX_FILE_SIZE = 24 // The maximum file size that will be cached (2^24 = 16MB)
    open static var MAX_CACHE_SIZE = 30 // The maximum file size that will be cached (2^30 = 256MB)
    open static var LOGGING = false // Set this to true to see all caching action in the output log
    open static var FORCE_LOWERCASE = true // Set this to false if you want to use case insensitive filename compare
    open static var _cacheDirectory: String!
    open static var _preCacheDirectory: String!
    open static var RECREATE_CACHE_RESPONSE = true // There is a difrence between unarchiving and recreating. I have to find out what.
    open static var IGNORE_CACHE_CONTROL = false // By default respect the cache control (and pragma) what is returned by the server
    fileprivate static var _filter = { _ in return true } as ((_ request: URLRequest) -> Bool)

    // Activate EVURLCache
    open class func activate() {
        // set caching paths
        _cacheDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]).appendingPathComponent(CACHE_FOLDER).absoluteString
        _preCacheDirectory = URL(fileURLWithPath: Bundle.main.resourcePath!).appendingPathComponent(PRE_CACHE_FOLDER).absoluteString

        let urlCache = EVURLCache(memoryCapacity: 1<<MAX_FILE_SIZE, diskCapacity: 1<<MAX_CACHE_SIZE, diskPath: _cacheDirectory)

        URLCache.shared = urlCache
        
        // TODO: Fix this protocol so that redirects are handled but normal pages are not influenced.
        //URLProtocol.registerClass(EVURLProtocol.self)

    }

    open class func filter (_ filterFor: @escaping ((_ request: URLRequest) -> Bool)) {
        _filter = filterFor
    }

    // Log a message with info if enabled
    open static func debugLog<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
        if LOGGING {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
            let process = ProcessInfo.processInfo
            let threadId = "." //NSThread.currentThread().threadDictionary
            print("\(dateFormatter.string(from: Date())) \(process.processName))[\(process.processIdentifier):\(threadId)] \((filename as NSString).lastPathComponent)(\(line)) \(funcname):\r\t\(object)\n")
        }
    }
    
    open static func shouldRedirect(request: URLRequest) -> URL? {
        if let cache = EVURLCache.cachedResponse(for: request) {
            if (cache.response as? HTTPURLResponse)?.statusCode == 302 {
                let headerFiels: [String:String] = (cache.response as? HTTPURLResponse)?.allHeaderFields as! [String : String]
                let redirectTo = headerFiels["Location"] ?? ""
                return URL(string: redirectTo)
            }
        }
        return nil
    }

    // Will be called by a NSURLConnection when it's wants to know if there is something in the cache.
    open override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        return EVURLCache.cachedResponse(for: request)
    }
    
    open static func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        guard let url = request.url else {
            EVURLCache.debugLog("CACHE not allowed for nil URLs")
            return nil
        }

        if url.absoluteString.isEmpty {
            EVURLCache.debugLog("CACHE not allowed for empty URLs")
            return nil
        }
        
        if !EVURLCache._filter(request) {
            EVURLCache.debugLog("CACHE skipped because of filter")
            return nil
        }

        // is caching allowed
        if ((request.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringCacheData || url.absoluteString.hasPrefix("file:/") || url.absoluteString.hasPrefix("data:")) && EVURLCache.networkAvailable()) {
            EVURLCache.debugLog("CACHE not allowed for \(url)")
            return nil
        }

        // Check if there is a cache for this request
        let storagePath = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory) ?? ""
        if !FileManager.default.fileExists(atPath: storagePath) {
            EVURLCache.debugLog("CACHE not found \(storagePath)")
            let storagePath = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory) ?? ""
            if !FileManager.default.fileExists(atPath: storagePath) {
                EVURLCache.debugLog("PRECACHE not found \(storagePath)")
                return nil
            }
        }

        // Check file status only if we have network, otherwise return it anyway.
        if EVURLCache.networkAvailable() {
            if cacheItemExpired(request, storagePath: storagePath) {
                let maxAge: String = request.value(forHTTPHeaderField: "Access-Control-Max-Age") ?? EVURLCache.MAX_AGE
                EVURLCache.debugLog("CACHE item older than \(maxAge) seconds")
                return nil
                
            }
        }

        // Read object from file
        if let response = NSKeyedUnarchiver.unarchiveObject(withFile: storagePath) as? CachedURLResponse {
            EVURLCache.debugLog("Returning cached data from \(storagePath)")

            // I have to find out the difrence. For now I will let the developer checkt which version to use
            if EVURLCache.RECREATE_CACHE_RESPONSE {
                // This works for most sites, but aperently not for the game as in the alternate url you see in ViewController
                if (response.response as? HTTPURLResponse)?.statusCode == 302 {
                    
                    let headerFiels: [String:String] = (response.response as? HTTPURLResponse)?.allHeaderFields as! [String : String]
                    let redirectTo = headerFiels["Location"] ?? ""
                    print("Redirecting from: \(response.response.url?.absoluteString ?? "")\nto: \(redirectTo)")
                    
                    // returning the actual redirect response
 //                   let r = URLResponse(url: URL(string: redirectTo)!, mimeType: response.response.mimeType, expectedContentLength: response.data.count, textEncodingName: response.response.textEncodingName)
//                    return CachedURLResponse(response: r, data: response.data, userInfo: response.userInfo, storagePolicy: .allowed)
                    
                    // returning the response of the redirected url
                    let redirectRequest = URLRequest(url: URL(string: redirectTo)!, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
                    return self.cachedResponse(for: redirectRequest)
                }
            
                let r = URLResponse(url: response.response.url!, mimeType: response.response.mimeType, expectedContentLength: response.data.count, textEncodingName: response.response.textEncodingName)
                return CachedURLResponse(response: r, data: response.data, userInfo: response.userInfo, storagePolicy: .allowed)
            }
            // This works for the game, but not for my site.
            return response
        } else {
            EVURLCache.debugLog("The file is probably not put in the local path using NSKeyedArchiver \(storagePath)")
        }
        return nil
    }

    // Will be called by NSURLConnection when a request is complete.
    open override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        if !EVURLCache._filter(request) {
            return
        }
        if let httpResponse = cachedResponse.response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                EVURLCache.debugLog("CACHE Do not cache error \(httpResponse.statusCode) page for : \(request.url?.absoluteString ?? "") \(httpResponse.debugDescription)")
                return
            }
        }

        var shouldSkipCache: String? = nil

        // check if caching is allowed according to the request
        if request.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringCacheData {
            shouldSkipCache = "request cache policy"
        }

        // check if caching is allowed according to the response Cache-Control or Pragma header
        if !EVURLCache.IGNORE_CACHE_CONTROL {
            if let httpResponse = cachedResponse.response as? HTTPURLResponse {
                if let cacheControl = httpResponse.allHeaderFields["Cache-Control"] as? String {
                    if cacheControl.lowercased().contains("no-cache")  || cacheControl.lowercased().contains("no-store") {
                        shouldSkipCache = "response cache control"
                    }
                }

                if let cacheControl = httpResponse.allHeaderFields["Pragma"] as? String {
                    if cacheControl.lowercased().contains("no-cache") {
                        shouldSkipCache = "response pragma"
                    }
                }
            }
        }
        if shouldSkipCache != nil {
            // If the file is in the PreCache folder, then we do want to save a copy in case we are without internet connection
            let storagePath = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory) ?? ""
            if !FileManager.default.fileExists(atPath: storagePath) {
                EVURLCache.debugLog("CACHE not storing file, it's not allowed by the \(shouldSkipCache.debugDescription) : \(request.url?.absoluteString ?? "")")
                return
            }
            EVURLCache.debugLog("CACHE file in PreCache folder, overriding \(shouldSkipCache.debugDescription) : \(request.url?.absoluteString ?? "")")
        }

        // create storrage folder
        let storagePath: String = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory) ?? ""
        if var storageDirectory: String = NSURL(fileURLWithPath: "\(storagePath)").deletingLastPathComponent?.absoluteString.removingPercentEncoding {
            do {
                if storageDirectory.hasPrefix("file:") {
                    storageDirectory = storageDirectory.substring(from: storageDirectory.characters.index(storageDirectory.startIndex, offsetBy: 5))
                }
                try FileManager.default.createDirectory(atPath: storageDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                EVURLCache.debugLog("Error creating cache directory \(storageDirectory)")
                EVURLCache.debugLog("Error \(error.debugDescription)")
            }
        }

        if let previousResponse = NSKeyedUnarchiver.unarchiveObject(withFile: storagePath) as? CachedURLResponse {
            if previousResponse.data == cachedResponse.data && !EVURLCache.cacheItemExpired(request, storagePath: storagePath) {
                EVURLCache.debugLog("CACHE not rewriting stored file")
                return
            }
        }

        // save file
        EVURLCache.debugLog("Writing data to \(storagePath)")
        if !NSKeyedArchiver.archiveRootObject(cachedResponse, toFile: storagePath) {
            EVURLCache.debugLog("Could not write file to cache")
        } else {
            EVURLCache.debugLog("CACHE save file to Cache  : \(storagePath)")
            // prevent iCloud backup
            if !EVURLCache.addSkipBackupAttributeToItemAtURL(URL(fileURLWithPath: storagePath)) {
                EVURLCache.debugLog("Could not set the do not backup attribute")
            }
        }
    }
    
    fileprivate static func cacheItemExpired(_ request: URLRequest, storagePath: String) -> Bool {
        // Max cache age for request
        let maxAge: String = request.value(forHTTPHeaderField: "Access-Control-Max-Age") ?? EVURLCache.MAX_AGE
        
        guard let maxAgeInterval: TimeInterval = Double(maxAge) else {
            EVURLCache.debugLog("MAX_AGE value string is incorrect")
            return false
        }
        
        return EVURLCache.fileExpired(storagePath: storagePath, maxAge: maxAgeInterval)
    }
    
    fileprivate static func fileExpired(storagePath: String, maxAge: Double) -> Bool {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: storagePath)
            if let modDate: Date = attributes[FileAttributeKey.modificationDate] as? Date {
                // Test if the file is older than the max age
                let modificationTimeSinceNow: TimeInterval = -modDate.timeIntervalSinceNow
                return modificationTimeSinceNow > maxAge
            }
        } catch {}
        
        return false
    }
    
    
    fileprivate static func cleanupPath(path: String) -> String {
        var result = path
        
        if path.hasPrefix("file:") {
            result = path.substring(from: path.index(path.startIndex, offsetBy: 5))
            var prevResult = String()
            
            while prevResult != result {
                prevResult = result
                result = result.replacingOccurrences(of: "//", with: "/")
            }
        }
        
        return result
    }
    
    
    // return the path if the file for the request is in the PreCache or Cache.
    open static func storagePathForRequest(_ request: URLRequest) -> String? {
        var storagePath: String? = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._cacheDirectory)
        if !FileManager.default.fileExists(atPath: storagePath ?? "") {
            storagePath = EVURLCache.storagePathForRequest(request, rootPath: EVURLCache._preCacheDirectory)
        }
        if !FileManager.default.fileExists(atPath: storagePath ?? "") {
            storagePath = nil
        }
        return storagePath?.removingPercentEncoding
    }

    // build up the complete storrage path for a request plus root folder.
    open static func storagePathForRequest(_ request: URLRequest, rootPath: String) -> String? {
        var localUrl: String = ""
        let host: String = request.url?.host ?? "default"

        let urlString = request.url?.absoluteString ?? ""
        if urlString.hasPrefix("data:") {
            return nil
        }

        // The filename could be forced by the remote server. This could be used to force multiple url's to the same cache file
        if let cacheKey = request.value(forHTTPHeaderField: URLCACHE_CACHE_KEY) {
            localUrl = "\(host)/\(cacheKey)"
        } else {
            if let path: String = request.url?.path {
                localUrl = "\(host)\(path)"
            } else {
                NSLog("WARNING: Unable to get the path from the request: \(request)")
                return nil
            }
        }

        // Without an extension it's treated as a folder and the file will be called index.html
        if let storageFile: String = localUrl.components(separatedBy: "/").last {
            if !storageFile.contains(".") {
                localUrl = "/\(localUrl)/index.html"
            }
        }

        if let query = request.url?.query {
            localUrl = "\(localUrl)_\(query)"
        }
        
        // Force case insensitive compare (OSX filesystem can be case sensitive)
        if FORCE_LOWERCASE {
            localUrl = "\(rootPath)/\(localUrl.lowercased())"
        } else {
            localUrl = "\(rootPath)/\(localUrl)"
        }
        
        // Cleanup
        localUrl = cleanupPath(path: localUrl)
        return localUrl.removingPercentEncoding
    }
    
    open static func addSkipBackupAttributeToItemAtURL(_ url: URL) -> Bool {
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
            return true
        } catch _ as NSError {
            debugLog("ERROR: Could not set 'exclude from backup' attribute for file \(url.absoluteString)")
        }
        return false
    }
    
    
    // Removes all files from _cacheDirectory with modification date more than MAX_AGE ago
    open static func cleanExpiredCaches() {
        let defaultFileManager = FileManager.default
        
        let storagePath = EVURLCache._cacheDirectory
        let storageDirectory: String = cleanupPath(path: storagePath!)
        
        guard let fileEnumerator = defaultFileManager.enumerator(atPath: storageDirectory) else { return }
        guard let maxAge: TimeInterval = Double(EVURLCache.MAX_AGE) else {
            EVURLCache.debugLog("MAX_AGE value string is incorrect")
            return
        }
        
        for url in fileEnumerator {
            if let filePath = url as? String {
                let fullPath = storageDirectory + filePath
                var isDirectory = ObjCBool(false)
                defaultFileManager.fileExists(atPath: fullPath, isDirectory: &isDirectory)
                
                if !isDirectory.boolValue && fileExpired(storagePath: fullPath, maxAge: maxAge) {
                    do {
                        try defaultFileManager.removeItem(atPath: fullPath)
                        EVURLCache.debugLog("Removed expired cache file: \(fullPath)")
                    } catch {
                        EVURLCache.debugLog("Failed to remove expired cache file: \(fullPath)")
                    }
                }
            }
        }
    }
    
    
    // Check if we have a network connection
    fileprivate static func networkAvailable() -> Bool {
        if let reachability = Reachability() {
            return reachability.isReachable
        }
        return false
    }
}
