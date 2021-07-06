//
//  URLSessionMock.swift
//  DVTWeatherUIKitTests
//
//  Created by Kurt Jacobs
//

import Foundation

enum URLProtocolMockRequests: String {
    case current = "https://api.openweathermap.org/data/2.5/weather?lat=22.0&lon=22.0&appid=b833cc84a378af044faafb0bada0ab3f&units=metric"
    case forecast = "https://api.openweathermap.org/data/2.5/forecast?lat=22.0&lon=22.0&appid=b833cc84a378af044faafb0bada0ab3f&units=metric"
}

class URLProtocolMock: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let urlString = request.url?.absoluteString else {
            return
        }
        let data = try! dataPayload(for: URLProtocolMockRequests(rawValue: urlString)!)
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: urlString)!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
    private func dataPayload(for request: URLProtocolMockRequests) throws -> Data {
        switch request {
        case .current:
            let data = try! DVTWeatherUIKitTests.load(file: "weather")
            return data
        case .forecast:
            let data = try! DVTWeatherUIKitTests.load(file: "forecast")
            return data
        }
    }
}

class URLProtocolMockFailing: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let urlString = request.url?.absoluteString else {
            return
        }
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: urlString)!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didFailWithError: NSError(domain: "dvt.weatherapp.unittests.failingURLMock", code: 9000, userInfo: nil))
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
