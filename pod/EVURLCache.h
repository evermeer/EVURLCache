//
//  EVURLCache.h
//  EVURLCacheTest2
//
//  Created by Gergely Nagy on 16.02.16.
//  Copyright © 2016 ElOpsis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef EVURLCache_h
#define EVURLCache_h

#define URLCACHE_CACHE_KEY @"MobileAppCacheKey" // Add this header variable to the response if you want to save the response using this key as the filename.
#define URLCACHE_EXPIRATION_AGE_KEY @"MobileAppExpirationAgeKey" // Add this header variable to the response to set the expiration age.
#define MAX_AGE @"604800000" // The default maximum age of a cached file in miliseconds. (1 week)
#define PRE_CACHE_FOLDER @"/PreCache/"  // The folder in your app with the prefilled cache content
#define CACHE_FOLDER @"/Cache/" // The folder in the Documents folder where cached files will be saved
#define MAX_FILE_SIZE 24 // The maximum file size that will be cached (2^24 = 16MB)
#define MAX_CACHE_SIZE 30
#ifndef EVURLCACHE_LOGGING
    #define EVURLCACHE_LOGGING false
#endif
#define FORCE_LOWECASE true
#define RECREATE_CACHE_RESPONSE true

@interface EVURLCache : NSURLCache

+(void)activate;
+(NSString*)storagePathForRequest:(NSURLRequest*)request;
+(NSString*)storagePathForRequest:(NSURLRequest*)request rootPath:(NSString*)rootPath;

@end

#endif /* EVURLCache_h */
