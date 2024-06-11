//
//  NetworkRequestTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class NetworkRequestTest: XCTestCase {
    var sut: NetworkRequest!

    func test_withNonEssentialFieldsUndefined_shouldUseDefaultImplementation() {
        sut = EmptyNetworkRequest()

        XCTAssertNil(sut.body, "Should not define a request body")
        XCTAssertNil(sut.bodyData, "Should not define a request body data")
        XCTAssertNil(sut.parameters, "Should not define a request parameters")
        XCTAssertFalse(sut.requiresAuthenticationToken, "Should not require authentication token")
        XCTAssertEqual(sut.additionalHeaderFields["Content-Type"], "application/json", "Should define proper Content-Type field")
        XCTAssertEqual(sut.additionalHeaderFields["Accept"], "application/json", "Should define proper Accept field")
        XCTAssertEqual(sut.cachePolicy, .reloadIgnoringCacheData, "Should use no caching policy")
    }

    func test_withRequestBody_shouldEncodeItToData() {
        sut = FakePostNetworkRequest()

        let body = sut.encodedBody

        let decodedBody = body?.decoded(into: FakeRequestBody.self)
        XCTAssertNotNil(decodedBody, "Should decode request body")
        XCTAssertEqual(decodedBody, sut.body as? FakeRequestBody, "Should decode the encoded body")
    }

    func test_withRequestBodyData_shouldUseBodyDataOverEncodableBody() {
        let fixtureBodyContent = "fixtureBodyContent"
        sut = FakePostNetworkRequest(bodyData: fixtureBodyContent.encoded())

        let body = sut.encodedBody

        let decodedBody = body?.decoded(into: String.self)
        XCTAssertNotNil(decodedBody, "Should decode request body")
        XCTAssertEqual(decodedBody, fixtureBodyContent, "Should decode the encoded body")
    }
}
