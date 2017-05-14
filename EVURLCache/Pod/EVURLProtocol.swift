//
//  EVURLProtocol.swift
//  EVURLCache
//
//  Created by Edwin Vermeer on 25/1/17.
//  Copyright © 2017 evict. All rights reserved.
//

import Foundation

/// The intercepting URL protocol.
internal final class EVURLProtocol: URLProtocol, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    /// Internal session object used to perform the request.
    private var internalSession: URLSession!
    
    /// Internal session data dark responsible for request execution.
    private var internalTask: URLSessionDataTask!
    
    /// Internal task response storage.
    private var internalResponse: HTTPURLResponse?
    
    /// Internal response data storage.
    private lazy var internalResponseData = NSMutableData()
    
    
    // MARK: NSURLProtocol
    
    internal override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        internalSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        internalTask = internalSession.dataTask(with: request)
    }
    
    internal override static func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    internal override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    internal override func startLoading() {
        internalTask.resume()
    }
    
    internal override func stopLoading() {
        internalSession.invalidateAndCancel()
    }
    
    
    // MARK: NSURLSessionTaskDelegate
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        let from = response.url
        let to = request.url
        print("====> Was redirected\n\tFrom: \(from?.absoluteString ?? "")\n\tTo: \(to?.absoluteString ?? "")")
        let cacheResponse = CachedURLResponse(response: response, data: Data())    
        let originalRequest = URLRequest(url: from!, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
        EVURLCache.shared.storeCachedResponse(cacheResponse, for: originalRequest)
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let _ = internalResponse {
            client?.urlProtocolDidFinishLoading(self)
        }
        internalSession.finishTasksAndInvalidate()
    }
    
    
    // MARK: NSURLSessionDataDelegate
    
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        internalResponse = response as? HTTPURLResponse
        completionHandler(.allow)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
    }
    
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        internalResponseData.append(data as Data)
        client?.urlProtocol(self, didLoad: data as Data)
    }
    
}
