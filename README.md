# EVURLCache
---

## What is this?

This is a NSURLCache subclass for handeling all web requests that use NSURLRequest. (This includes UIWebView)

The EVURLCache is meant for handeling the following caching strategy:
- The app has to be functional even if there is no internet connection right after the app has 
been downloaden from the app store. This means that the required content is included in the app.
- You do want to be a able to download new/updated content if it's available.

## How to use this

Include the EVURLCache.m and .h and the Reachability .m and .h files in your project
Add the following import to your AppDelegate.m : #import "EVURLCache.h"
Add the following line to the AppDelegate didFinishLaunchingWithOptions : [EVURLCache activate];

## Extra functionality

Since all files will be cached, you do not have to handle incoming data yourself.
You can do a NSURLRequest and then in the connectionDidFinishLoading you can use the file from 
the cache. You can get the full path of that file by calling: [EVURLCache storagePathForRequest:theRequest]

## Creating the initial cache

Put all the files that you want to be available from the start in the folder /PreCache
The easiest way to add this to your project is to select 'add files' and then select the folder 
and select 'create folder reference for any added folders'

If you are not sure what files you would need to include in the PreCache folder, then just run 
your app with the EVURLCache enabled in the simulator and execute all the functions that needs to 
be functional without an internet connection. Then browse to the files (see ~/Library/Application Support/iPhone Simulator/ ...)
The downloaded files will be in the Documents/Cache folder. You can copy these files to the PreCache folder

## Compatibility

This cache should work with all download libraries that use a NSURLRequest for downloading 
from the web (Like AFNetworking). It also works for every request in a UIWebview.

## Limitations

Downloaded files will be completely in memory before they are written to disk. Because of this large 
files will not be cached. The maximum file size can be influenced by setting the MAX_FILE_SIZE in the EVURLCache.h

## Debugging

If you are having problems setting EVURLCache up, then enable logging. You can do that by enabeling line 32 of EVURLCache.h. It's the line that says: //#define CACHE_DEBUG_MODE

## Possible future improvements

Ideas for people who might want to hack on this:

1. Use the default caching for requests that come from an other domain. See the TODO in the EVURLCache.m
2. Adding a sample app.
2. anything else?

## License
EVURLCache is available under the MIT 3 license. See the LICENSE file for more info.

## My other libraries:
Also see my other open source iOS libraries:

- [EVReflection](https://github.com/evermeer/EVReflection) - Swift library with reflection functions with support for NSCoding, Printable, Hashable, Equatable and JSON 
- [EVCloudKitDao](https://github.com/evermeer/EVCloudKitDao) - Simplified access to Apple's CloudKit
- [EVFaceTracker](https://github.com/evermeer/EVFaceTracker) - Calculate the distance and angle of your device with regards to your face in order to simulate a 3D effect
- [EVURLCache](https://github.com/evermeer/EVURLCache) - a NSURLCache subclass for handling all web requests that use NSURLReques
- [AlamofireJsonToObject](https://github.com/evermeer/AlamofireJsonToObjects) - An Alamofire extension which converts JSON response data into swift objects using EVReflection
- [AlamofireOauth2](https://github.com/evermeer/AlamofireOauth2) - A swift implementation of OAuth2 using Alamofire
- [EVWordPressAPI](https://github.com/evermeer/EVWordPressAPI) - Swift Implementation of the WordPress (Jetpack) API using AlamofireOauth2, AlomofireJsonToObjects and EVReflection (work in progress)
- [PassportScanner](https://github.com/evermeer/PassportScanner) - Scan the MRZ code of a passport and extract the firstname, lastname, passport number, nationality, date of birth, expiration date and personal numer.
