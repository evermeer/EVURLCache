# EVURLCache
---

## What is this?

This is a NSURLCache subclass for handeling all web requests that use NSURLRequest. (This includes UIWebView)

The EVURLCache is meant for handeling the following caching strategy:
- The app has to be functional even if there is no internet connection right after the app has 
been downloaden from the app store. This means that the required content is included in the app.
- You do want to be a able to download new/updated content if it's available.

## How to use this

Include the EVURLCache.m and .h files in your project
Add the following import to your AppDelegate.m : #import "EVURLCache.h"
Add the following line to the AppDelegate didFinishLaunchingWithOptions : [EVURLCache activate];

## Optional functionality

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

## Possible future improvements

Ideas for people who might want to hack on this:

1. Use the default caching for requests that come from an other domain. See the TODO in the EVURLCache.m
2. Adding a sample app.
2. anything else?

## License

MIT License

    Copyright (c) 2013 EVICT B.V.
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.