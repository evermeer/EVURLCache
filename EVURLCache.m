//
//
//  Created by Edwin Vermeer on 20/01/11.
//  Copyright 2011 EVICT B.V. All rights reserved.
//
// See the .h for extra info

#import "EVURLCache.h"
#import <sys/stat.h>
#include <sys/xattr.h>
#include "Reachability.m"

static NSString* _cacheDirectory;
static NSString* _preCacheDirectory;

@implementation EVURLCache


#pragma mark - Initialisation

// static method for activating this custom cache
+(void)activate {
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


#pragma mark - NSURLRequest callback methods

// NSURLRequest calls will call this method before the request is executed (exept for protocol NSURLRequestReloadIgnoringLocalCacheData)
// Here we will return the cached data or nil if we need to refresh the data.
-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    CacheDebugLog(@"CACHE REQUEST %@", request);
    
    // is caching allowed
    if ((request.cachePolicy == NSURLCacheStorageNotAllowed || [request.URL.absoluteString hasPrefix:@"file://"] || [request.URL.absoluteString hasPrefix:@"data:"]) && [EVURLCache networkAvailable]) {
		CacheDebugLog(@"CACHE not allowed for %@", request.URL);
		return nil;
    }
    
    // Is the file in the cache? If not, is the file in the PreCache?
	NSString* storagePath = [EVURLCache storagePathForRequest:request andRootPath:_cacheDirectory];
	if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
        storagePath = [EVURLCache storagePathForRequest:request andRootPath:_preCacheDirectory];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
		CacheDebugLog(@"CACHE found for %@", storagePath);
        
        if ([EVURLCache networkAvailable]) {
            // Max cache age for request
            NSString *maxAge = [request valueForHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY];
            if (maxAge == nil || [maxAge floatValue] == 0) {
                maxAge = MAX_AGE;
            }
            
            // Last modification date for file
            NSError* error = nil;
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:storagePath error:&error];
            NSDate* modDate = [attributes objectForKey:NSFileModificationDate];
            
            // Test if the file is older than the max age
            NSTimeInterval threshold = (NSTimeInterval)[maxAge doubleValue];
            NSTimeInterval modificationTimeSinceNow = -[modDate timeIntervalSinceNow];
            if (modificationTimeSinceNow > threshold) {
                CacheDebugLog(@"CACHE item older than %@ maxAgeHours", maxAge);
                return nil;
            }
            CacheDebugLog(@"CACHE max age = %@, file date = %@", maxAge, modDate);
        }
        
        // Return the cache response
		NSData* content = [NSData dataWithContentsOfFile:storagePath];
		NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:@"cache" expectedContentLength:[content length] textEncodingName:nil] ;
		return [[NSCachedURLResponse alloc] initWithResponse:response data:content] ;
	}
    
    CacheDebugLog(@"CACHE not found %@", storagePath);
    return nil;
	
}

// After a file has been downloaded by the NSURLRequest this method will be called.
// This is where we save the data to our cache.
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    // check if caching is allowed
    if (request.cachePolicy == NSURLCacheStorageNotAllowed) {
        // If the file is in the PreCache folder, then we do want to save a copy in case we are without internet connection
        NSString* storagePath = [EVURLCache storagePathForRequest:request andRootPath:_preCacheDirectory];
        if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
            CacheDebugLog(@"CACHE not storing file, it's not allowed by the cachePolicy : %@", request.URL);
            return;
        }
        CacheDebugLog(@"CACHE file in PreCache folder, overriding cachePolicy : %@", request.URL);
    }
    
    // create storrage folder
    NSString* storagePath = [EVURLCache storagePathForRequest:request andRootPath:_cacheDirectory];
	NSString *storageDirectory = [storagePath stringByDeletingLastPathComponent];
	NSError* error = nil;
	if (![[NSFileManager defaultManager] createDirectoryAtPath:storageDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
		CacheDebugLog(@"Error creating cache directory: %@", error);
	}
    
    
    // save file
    CacheDebugLog(@"Writing data to %@", storagePath);
	if (![[cachedResponse data] writeToFile:storagePath atomically:YES]) {
		CacheDebugLog(@"Could not write file to cache");
	} else {
        // prevent iCloud backup
        NSURL *cacheURL = [NSURL fileURLWithPath:storagePath];
        if (![EVURLCache addSkipBackupAttributeToItemAtURL:cacheURL]){
            CacheDebugLog(@"Could not set the do not backup attribute");
        }
    }
	
    //TODO: Make above saving conditional (if url domain == settings domain) otherwise execute default caching meganism below.
	//[super storeCachedResponse:cachedResponse forRequest:request];
    //	CacheDebugLog( @"CACHE currentDiskUsage:   %@", [NSString stringWithFormat:@"%d/%d", [self currentDiskUsage], [self diskCapacity]]);
    //	CacheDebugLog( @"CACHE currentMemoryUsage: %@", [NSString stringWithFormat:@"%d/%d", [self currentMemoryUsage], [self memoryCapacity]]);
}


#pragma mark - helper methods

// return the path if the file for the request is in the PreCache or Cache.
+(NSString *)storagePathForRequest:(NSURLRequest*)request {
	NSString* storagePath = [EVURLCache storagePathForRequest:request andRootPath:_cacheDirectory];
	if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
        storagePath = [EVURLCache storagePathForRequest:request andRootPath:_preCacheDirectory];
    }
	if (![[NSFileManager defaultManager] fileExistsAtPath:storagePath]) {
        storagePath = nil;
    }
    return storagePath;
}

// Private method for generating the Cache file path for a request.
+(NSString *)storagePathForRequest:(NSURLRequest*)request andRootPath:(NSString*) path {
	NSString *cacheKey = [request valueForHTTPHeaderField:URLCACHE_CACHE_KEY];
	NSString *localUrl;
	if (cacheKey==nil) {
		localUrl = [NSString stringWithFormat:@"%@%@", path, [[request.URL relativePath] lowercaseString]];
	} else {
		localUrl = [NSString stringWithFormat:@"%@/%@", path, cacheKey];
	}
	NSString *storageFile = [[localUrl componentsSeparatedByString: @"/"] lastObject];
	if ([storageFile rangeOfString:@"."].location == NSNotFound) {
		return [NSString stringWithFormat:@"%@/index.html", localUrl];
	}
	return localUrl;
}

// We do not want to backup this file to iCloud
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
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

