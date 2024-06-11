//
//  NetworkModuleActionTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 11/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class NetworkModuleActionTests: XCTestCase {
    var sut: NetworkModuleAction!

    override func setUp() {
        sut = EmptyNetworkModuleAction()
    }

    func test_shouldNotChangeOutgoingRequest() {
        let fakeRequest = FakeGetNetworkRequest(path: "/welcome")
        let fixtureUrl = URL(string: "https://google.com")!
        let fixtureResponse = NetworkResponse(
            data: nil,
            networkResponse: HTTPURLResponse(
                url: fixtureUrl,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
        var fixtureUrlRequest = URLRequest(url: fixtureUrl)
        let fixtureOriginalUrlRequest = fixtureUrlRequest

        sut.performBeforeExecutingNetworkRequest(request: fakeRequest, urlRequest: &fixtureUrlRequest)
        sut.performAfterExecutingNetworkRequest(request: fakeRequest, networkResponse: fixtureResponse)

        XCTAssertEqual(fixtureOriginalUrlRequest, fixtureUrlRequest, "Should not change the original request")
    }
}

private final class EmptyNetworkModuleAction: NetworkModuleAction {}
