//
//  EVURLCache.m
//  EVURLCacheTest2
//
//  Created by Gergely Nagy on 16.02.16.
//  Copyright © 2016 ElOpsis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/stat.h>
#include <sys/xattr.h>
#import "EVURLCache.h"
#import "Reachability.h"

static NSString* _cacheDirectory;
static NSString* _preCacheDirectory;

@implementation EVURLCache


+(void)activate
{
    // set caching paths
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    _cacheDirectory = [documentDirectory stringByAppendingPathComponent:CACHE_FOLDER]; 
    mkdir( [_cacheDirectory UTF8String], 0700 );
    _preCacheDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PRE_CACHE_FOLDER];
    
    // activate cache
    EVURLCache *urlCache = [[EVURLCache alloc] initWithMemoryCapacity:(1<<MAX_FILE_SIZE) diskCapacity:(1<<MAX_FILE_SIZE) diskPath:_cacheDirectory] ;
    [NSURLCache setSharedURLCache:urlCache];
}


// initializing the cache. Only used by the method above.
-(id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)diskPath {
    if ((self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:diskPath])) {
    }
    return self;
}

-(NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request{
    
    if(request.URL == nil)
    {
        NSLog(@"CACHE not allowed for NULL urls");
        return nil;
    }
    if(request.URL.absoluteString.length == 0)
    {
        NSLog(@"CACHE not allowed for emtpy urls");
        return nil;
    }
    // is caching allowed
    if(request.cachePolicy == NSURLRequestReloadIgnoringCacheData || [request.URL.absoluteString hasPrefix:@"file:/"] || ([request.URL.absoluteString hasPrefix:@"data:"] && [EVURLCache networkAvailable]))
    {
        NSLog(@"CACHE not allowed for url %@", request.URL.absoluteString);
        return nil;
    }
    
    // Is the file in the cache? If not, is the file in the PreCache?
    NSString* storagePath = [EVURLCache storagePathForRequest:request rootPath:_cacheDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:storagePath])
    {
        storagePath = [EVURLCache storagePathForRequest:request rootPath:_preCacheDirectory];
        if(![fileManager fileExistsAtPath:storagePath])
        {
            NSLog(@"CACHE not found in %@", storagePath);
            return nil;
        }
    }

    // Check file status only if we have network, otherwise return it anyway.
    if([EVURLCache networkAvailable])
    {
        NSString* maxAge = [request valueForHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY] ? [request valueForHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY] : MAX_AGE;

        NSDictionary *attributes = [fileManager attributesOfItemAtPath:storagePath error:nil];
        NSDate* modDate = [attributes fileModificationDate];
        if([modDate isKindOfClass:[NSDate class]])
        {
            NSTimeInterval threshold = [maxAge doubleValue];
            if(threshold != 0)
            {
                NSTimeInterval modificationTimeSinceNow = -[modDate timeIntervalSinceNow];
                if(modificationTimeSinceNow > threshold)
                {
                    NSLog(@"CACHE item older than %@ maxAgeHours", maxAge);
                    return nil;
                }
            }
        }
    }
    
    // Read object from file
    NSCachedURLResponse *response = [NSKeyedUnarchiver unarchiveObjectWithFile:storagePath];
    if(response != nil)
    {
        NSLog(@"Returning cached data from %@", storagePath);
        if(RECREATE_CACHE_RESPONSE)
        {
            NSURLResponse *r = [[NSURLResponse alloc] initWithURL:response.response.URL MIMEType:response.response.MIMEType expectedContentLength:response.data.length textEncodingName:response.response.textEncodingName];
            return [[NSCachedURLResponse alloc] initWithResponse:r data:response.data userInfo:response.userInfo storagePolicy:NSURLCacheStorageAllowed];
        }
        return response;
    }else{
        NSLog(@"The file is probably not put in the local path using NSKeyedArchiver %@", storagePath);
    }
    return nil;
}

// Will be called by NSURLConnection when a request is complete.
-(void)storeCachedResponse:(NSCachedURLResponse*)cachedResponse forRequest:(nonnull NSURLRequest *)request
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSHTTPURLResponse *httpResponse = cachedResponse.response;
    if(httpResponse != nil && httpResponse.statusCode >= 400)
    {
        NSLog(@"CACHE Do not cache error %li page for: %@", (long)httpResponse.statusCode, request.URL);
        return;
    }
    
    // check if caching is allowed
    if(request.cachePolicy == NSURLRequestReloadIgnoringCacheData)
    {
        NSString *storagePath = [EVURLCache storagePathForRequest:request rootPath:_preCacheDirectory];
        if(![fileManager fileExistsAtPath:storagePath])
        {
            NSLog(@"CACHE not storing file, it's not allowed by the cachePolicy : %@", request.URL);
            return;
        }
        NSLog(@"CACHE file in PreCache folder, overriding cachePolicy : %@", request.URL);
    }
    
    // create storrage folder
    NSString *storagePath = [EVURLCache storagePathForRequest:request rootPath:_cacheDirectory];
    NSString *storageDirectory = [[NSURL fileURLWithPath:storagePath] URLByDeletingLastPathComponent].absoluteString.stringByRemovingPercentEncoding;
    if(storageDirectory != nil)
    {
        if([storageDirectory hasPrefix:@"file:"]){
            storageDirectory = [storageDirectory substringFromIndex: 5];
        }
        [fileManager createDirectoryAtPath:storageDirectory withIntermediateDirectories:true attributes:nil error:nil];
    }
    // save file
    NSLog(@"Writing data to %@", storagePath);
    if(![NSKeyedArchiver archiveRootObject:cachedResponse toFile:storagePath])
    {
        NSLog(@"Could not write file to cache");
    }
    else
    {
        if(![EVURLCache addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:storagePath]])
        {
            NSLog(@"Could not set the do not backup attribute");
        }
    }
}

// return the path if the file for the request is in the PreCache or Cache.
+(NSString*)storagePathForRequest:(NSURLRequest*)request
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *storagePath = [EVURLCache storagePathForRequest:request rootPath:_cacheDirectory];
    if(![fileManager fileExistsAtPath:storagePath])
    {
        storagePath = [EVURLCache storagePathForRequest:request rootPath:_preCacheDirectory];
    }
    if(![fileManager fileExistsAtPath:storagePath])
    {
        storagePath = nil;
    }
    return storagePath;
}

// build up the complete storrage path for a request plus root folder.
+(NSString*)storagePathForRequest:(NSURLRequest*)request rootPath:(NSString*)rootPath
{
    NSString *localUrl;
    NSString *host = request.URL.host ? request.URL.host : @"default";
    // The filename could be forced by the remote server. This could be used to force multiple url's to the same cache file
    NSString *cacheKey = [request valueForHTTPHeaderField:URLCACHE_CACHE_KEY];
    if(cacheKey)
    {
        localUrl = [host stringByAppendingString:cacheKey];
    }
    else
    {
        localUrl = request.URL.relativePath;
    }
    if(localUrl)
    {
        localUrl = [host stringByAppendingString:localUrl];
        localUrl = [@"/" stringByAppendingString:localUrl];
    }
    else
    {
        NSLog(@"WARNING: Unable to get the path from the request: %@", request);
        return @"";
    }
    
    // Without an extension it's treated as a folder and the file will be called index.html
    NSString *storageFile = [localUrl componentsSeparatedByString:@"/"].lastObject;
    if(storageFile)
    {
        if(![storageFile containsString:@"."])
        {
            localUrl = [localUrl stringByAppendingString:@"/index.html"];
        }
    }
    
    // Force case insensitive compare (OSX filesystem can be case sensitive)
    if(FORCE_LOWECASE)
    {
        localUrl = [rootPath stringByAppendingString:localUrl.lowercaseString];
    }
    else
    {
        localUrl = [rootPath stringByAppendingString:localUrl];
    }
    
    // Cleanup
    if([localUrl hasPrefix:@"file:"])
    {
        localUrl = [localUrl substringFromIndex:5];
    }
    localUrl = [localUrl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    localUrl = [localUrl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    return localUrl;
}

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    if (&NSURLIsExcludedFromBackupKey == nil) {
        // iOS 5.0.1 and lower
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else {
        // First try and remove the extended attribute if it is present
        int result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
        if (result != -1) {
            // The attribute exists, we need to remove it
            int removeResult = removexattr(filePath, attrName, 0);
            if (removeResult == 0) {
                NSLog(@"Removed extended attribute on file %@", URL);
            }
        }
        
        // Set the new key
        return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }

}

+(BOOL)networkAvailable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return TRUE;
    }
    return FALSE;
}

@end