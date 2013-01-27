//
//
//  Created by Edwin Vermeer on 20/01/11.
//  Copyright 2011 EVICT B.V. All rights reserved.
//
// Usage: After calling the line below all NSURLRequest calls will use this cache.
// You can put it in your AppDelegate didFinishLaunchingWithOptions for caching all requests
// [MirabeauCommonsCustomURLCache activate];
// NSURLRequest is also used by the UIWebview.
//
// Extra parameters can be pased using these header varialbles:
// [request addValue:[NSString stringWithFormat:@"%f", maxAge] forHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY];
// [request addValue:[NSString stringWithFormat:@"%@", cacheKey] forHTTPHeaderField:URLCACHE_CACHE_KEY];
//
// If you want to use these parameters with a UIWebView, then you can do this by
// using 'Method Swizzling' for adding the required extra HTTP Header field
// See: http://www.icab.de/blog/2010/04/07/changing-the-headers-for-uiwebkit-http-requests/

#import <Foundation/Foundation.h>


#define URLCACHE_CACHE_KEY @"MobileAppCacheKey" // Add this header variable to the response if you want to save the response using this key as the filename.
#define URLCACHE_EXPIRATION_AGE_KEY @"MobileAppExpirationAgeKey" // Add this header variable to the response to set the expiration age.
#define MAX_AGE @"604800000" // The default maximum age of a cached file in miliseconds. (1 week)
#define PRE_CACHE_FOLDER @"/PreCache/"  // The folder in your app with the prefilled cache content
#define CACHE_FOLDER @"/Cache/" // The folder in the Documents folder where cached files will be saved
#define MAX_FILE_SIZE 24 // The maximum file size that will be cached (2^24 = 16MB)

///
/// Uncomment CACHE_DEBUG_MODE to enable logging
///
//#define CACHE_DEBUG_MODE
#ifdef CACHE_DEBUG_MODE
#define CacheDebugLog( s, ... ) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define CacheDebugLog( s, ... )
#endif

@interface EVURLCache : NSURLCache {
}

+(void)activate ;
+(NSString *)storagePathForRequest:(NSURLRequest*)request;

@end


