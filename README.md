# EVURLCache

<!---
[![Circle CI](https://img.shields.io/circleci/project/evermeer/EVURLCache.svg?style=flat)](https://circleci.com/gh/evermeer/EVURLCache)
 -->
[![Build Status](https://travis-ci.org/evermeer/EVURLCache.svg?style=flat)](https://travis-ci.org/evermeer/EVURLCache)
[![Issues](https://img.shields.io/github/issues-raw/evermeer/EVURLCache.svg?style=flat)](https://github.com/evermeer/EVURLCache/issues)
[![Documentation](https://img.shields.io/badge/documented-100%-brightgreen.svg?style=flat)](http://cocoadocs.org/docsets/EVURLCache)
[![Stars](https://img.shields.io/github/stars/evermeer/EVURLCache.svg?style=flat)](https://github.com/evermeer/EVURLCache/stargazers)

[![Version](https://img.shields.io/cocoapods/v/EVURLCache.svg?style=flat)](http://cocoadocs.org/docsets/EVURLCache)
[![Language](https://img.shields.io/badge/language-swift2-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/cocoapods/p/EVURLCache.svg?style=flat)](http://cocoadocs.org/docsets/EVURLCache)
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20|%20OSX%2010.9+%20|%20WOS%202+|%20TVOS%209+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![License](https://img.shields.io/cocoapods/l/EVURLCache.svg?style=flat)](http://cocoadocs.org/docsets/EVURLCache)

[![Git](https://img.shields.io/badge/GitHub-evermeer-blue.svg?style=flat)](https://github.com/evermeer)
[![Twitter](https://img.shields.io/badge/twitter-@evermeer-blue.svg?style=flat)](http://twitter.com/evermeer)
[![LinkedIn](https://img.shields.io/badge/linkedin-Edwin Vermeer-blue.svg?style=flat)](http://nl.linkedin.com/in/evermeer/en)
[![Website](https://img.shields.io/badge/website-evict.nl-blue.svg?style=flat)](http://evict.nl)
[![eMail](https://img.shields.io/badge/email-edwin@evict.nl-blue.svg?style=flat)](mailto:edwin@evict.nl?SUBJECT=About EVURLCache)


## What is this?
 
This is a NSURLCache subclass for handeling all web requests that use NSURLRequest. (This includes UIWebView)

The EVURLCache is meant for handeling the following caching strategies:

- The app has to be functional even if there is no internet connection. 
- The app has to be functional right after the app has  been downloaden from the app store. (This means that the required content can be included in the app.)
- You do want to be a able to download new/updated content if it's available.

## Extra functionality

Since (most likely, see limitations) all files will be cached, you do not have to handle incoming data yourself.
You can do a NSURLRequest and then in the connectionDidFinishLoading you can use the file from 
the cache. You can get the full path of that file by calling: EVURLCache.storagePathForRequest(theRequest)

## Controlling the cache

EVURLCache respects the HTTP header variables 'Cache-Control' and 'Pragma' when these contain 'no-cache' or 'no-store' then the response will not be written to the cache. You do have to be aware that if the file is already in the cache because you have put it in the PreCache folder yourself or the file was previously fetched with different header variables, the file will be written to the cache in order to update it's contents and the HTTP header varialbes will be ignored.

EVURLCache will also take into account the HTTP header variable 'Access-Control-Max-Age' when reading from the cache. When the content is older it will try to fetch it again.

Caching is done based on the complete URL including the querystring parameters. If for some reason you want multiple URL's to be stored and fetched as the same cache item, then you can add the HTTP header variable (server side) MobileAppCacheKey

Most webservers interpit url's' case insesnsitive. Since iOS and OSX (not always) have a case sensitive file system it could be that a URL is requested that do not have a case sensitive match on the file system. By default EVURLCache stores all files while converting the path to lowercase. If you do want a case sensitive match, then you could set the EVURLCache.FORCE_LOWERCASE to false

You can influence the maximum file size that will be cached by EVURLCache. This is a setting that is handled by the NSURLCache base class. By default it's set to 16MB. You can influence this by setting the EVURLCache.MAX_FILE_SIZE. It's set as number of bits. So setting it to 24 will mean a cache size of  2^24 = 16MB

You can influence the maximum total size that will be cached by EVURLCache. This is a setting that is handled by the NSURLCache base class. By default it's set to 256MB. You can influence this by setting the EVURLCache.MAX_CACHE_SIZE It's set as number of bits. So setting it to 30 will mean a cache size of 2^30 = 256MB. Make sure it's at least 16 times larger than the Maximum file size or the maximum file size will not be used

If you want to see what EVURLCache is doing, then set EVURLCache.LOGGING to true

## See the demo in action

Follow these steps to see the demo app in action. Logging is enabled, so watch the output window to see what's happening.

- Make sure the demo app is not on your phone and set it in airplaine mode.
- Start up the app. You should still see the homepage of my website because it's in the PreCache
- Select any other page from the menu. You won't see anything happening because none of these are in the PreCache or Cache folder
- Turn airplaine mode off and select a menu option. You will then just see that page.
- Turn airplaine mode on and navigate back to the homepage. You can now also go to the page you selected in the previous step becaus it has been cached. Other pages are still unavailable.

## Creating the initial cache

Just put all the files that you want to be available from the start in the folder /PreCache. The directory required directory structure will be the same as the complete url. So evict.nl/ios/samples/index.html has to be stored in the /PreCache/evict.nl/ios/samples/ folder.
The easiest way to add this to your project is to select 'add files' and then select the folder and select 'create folder reference for any added folders'

If you are not sure what files you would need to include in the PreCache folder, then just run your app with the EVURLCache enabled in the simulator and execute all the functions that needs to be functional without an internet connection. Then browse to the files (see ~/Library/Application Support/iPhone Simulator/ ...) The downloaded files will be in the Documents/Cache folder. See the output window for the exact location (if debugging is enabled). You can copy these files to the PreCache folder

## Compatibility

This cache should work with all download libraries that use a NSURLRequest for downloading from the web (Like AFNetworking and Alamofire). It also works for every request in a UIWebview.

## Limitations

Downloaded files will be completely in memory before they are written to disk. Because of this large files will not be cached. The maximum file size can be influenced by setting the MAX_FILE_SIZE in the EVURLCache.swift

## Usage

Just put the folowing code in your AppDelegate.swift

```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    EVURLCache.LOGGING = true // We want to see all caching actions
    EVURLCache.MAX_FILE_SIZE = 26 // We want more than the default: 2^26 = 64MB
    EVURLCache.MAX_CACHE_SIZE = 30 // We want more than the default: 2^30 = 1GB
    EVURLCache.activate()
    return true
}
```


## Debugging

If you are having problems setting EVURLCache up, then enable logging. You can do that by setting EVURLCache.logging = true
When reporting an issue, it helps when including this output.

## Using EVURLCache in your own App

'EVURLCache' is now available through the dependency manager [CocoaPods](http://cocoapods.org). 
You do have to use cocoapods version 0.36 or later. At this moment this can be installed by executing:

```
[sudo] gem install cocoapods
```

If you have installed cocoapods version 0.36 or later, then you can just add EVURLCache to your workspace by adding the folowing 2 lines to your Podfile:

```
use_frameworks!
pod "EVURLCache"
```

Version 0.36 or later of cocoapods will make a dynamic framework of all the pods that you use. Because of that it's only supported in iOS 8.0 or later. When using a framework, you also have to add an import at the top of your swift file like this:

```
import EVURLCache
```

If you want support for older versions than iOS 8.0, then you can also just copy the EVURLCache.swift plus the [ReachabilitySwift.swift](https://github.com/ashleymills/Reachability.swift) to your app.

## Building the EVURLCache demo

1) Clone the repo to a working directory

2) [CocoaPods](http://cocoapods.org) is used to manage dependencies. Pods are setup easily and are distributed via a ruby gem. Follow the simple instructions on the website to setup. After setup, run the following command from the toplevel directory of EVURLCache to download the dependencies for EVURLCache:

```sh
pod install
```

3) Open the `EVURLCache.xcworkspace` in Xcode and run the app.


## License

EVURLCache is available under the MIT 3 license. See the LICENSE file for more info.

## My other libraries:
Also see my other open source iOS libraries:

- [EVReflection](https://github.com/evermeer/EVReflection) - Swift library with reflection functions with support for NSCoding, Printable, Hashable, Equatable and JSON 
- [EVCloudKitDao](https://github.com/evermeer/EVCloudKitDao) - Simplified access to Apple's CloudKit
- [EVFaceTracker](https://github.com/evermeer/EVFaceTracker) - Calculate the distance and angle of your device with regards to your face in order to simulate a 3D effect
- [EVURLCache](https://github.com/evermeer/EVURLCache) - a NSURLCache subclass for handling all web requests that use NSURLReques
- [AlamofireJsonToObject](https://github.com/evermeer/AlamofireJsonToObjects) - An Alamofire extension which converts JSON response data into swift objects using EVURLCache
- [AlamofireXmlToObject](https://github.com/evermeer/AlamofireXmlToObjects) - An Alamofire extension which converts XML response data into swift objects using EVURLCache and XMLDictionary
- [AlamofireOauth2](https://github.com/evermeer/AlamofireOauth2) - A swift implementation of OAuth2 using Alamofire
- [EVWordPressAPI](https://github.com/evermeer/EVWordPressAPI) - Swift Implementation of the WordPress (Jetpack) API using AlamofireOauth2, AlomofireJsonToObjects and EVURLCache (work in progress)
- [PassportScanner](https://github.com/evermeer/PassportScanner) - Scan the MRZ code of a passport and extract the firstname, lastname, passport number, nationality, date of birth, expiration date and personal numer.
