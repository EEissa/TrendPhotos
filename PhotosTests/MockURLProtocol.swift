//
//  MockURLProtocol.swift
//  PhotosTests
//
//  Created by Essam on 01/02/2022.
//

import Foundation

public final class MockURLProtocol: URLProtocol {
    
    static var responseType: ResponseType!
    private(set) var activeTask: URLSessionTask?
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }()
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    public override func startLoading() {
        activeTask = session.dataTask(with: request)
        activeTask?.cancel()
    }
    
    public override func stopLoading() {
        activeTask?.cancel()
    }
}

extension MockURLProtocol: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
            case .error(let error)?:
                client?.urlProtocol(self, didFailWithError: error)
            case .success(let response)?:
                client?.urlProtocol(self, didLoad: response.data)
                client?.urlProtocol(self, didReceive: response.response, cacheStoragePolicy: .notAllowed)
            default:
                break
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {
    static func responseWithFailure(error: Error) {
        MockURLProtocol.responseType = .error(error)
    }
    
    static func responseWithStatusCode(code: Int, data: Data) {
        let response = HTTPURLResponse(url: URL(string: "http://any.com")!,
                                       statusCode: code,
                                       httpVersion: nil, headerFields: nil)!
        MockURLProtocol.responseType = .success((response: response, data: data))
    }
}

extension MockURLProtocol {
    enum ResponseType {
        case error(Error)
        case success((response: HTTPURLResponse, data: Data))
    }
}
