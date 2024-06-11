//
//  FakeNetworkSession.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation

@testable import DevNetworking

final class FakeNetworkSession: NetworkSession {
    var simulatedURLSessionDataTask: URLSessionDataTask?
    private(set) var lastProcessedRequest: URLRequest?
    private var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return simulatedURLSessionDataTask ?? URLSession.shared.dataTask(with: request)
    }
}

extension FakeNetworkSession {

    func simulateSuccess(data: Data?, response: URLResponse?) {
        completionHandler?(data, response, nil)
    }

    func simulateFailure(response: URLResponse?, error: Error?) {
        completionHandler?(nil, response, error)
    }
}
