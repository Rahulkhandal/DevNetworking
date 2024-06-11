//
//  FakeRequestBuilder.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation

@testable import DevNetworking

final class FakeRequestBuilder: RequestBuilder {
    var simulatedUrlRequest: URLRequest?

    func build(request: NetworkRequest) -> URLRequest? {
        simulatedUrlRequest
    }
}
