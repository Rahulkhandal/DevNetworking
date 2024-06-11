//
//  DefaultRequestBuilderTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class DefaultRequestBuilderTests: XCTestCase {
    let fixtureBaseUrl = URL(string: "https://fixture.url.com")!
    var sut: DefaultRequestBuilder!

    override func setUp() {
        sut = DefaultRequestBuilder(baseURL: fixtureBaseUrl)
    }

    func test_whenProvidedWithPostRequestAbstraction_shouldBuildProperPostUrlRequest() {
        let fixturePath = "/fixture/path"
        let fixtureHeaderFieldName = "fieldName"
        let fixtureHeaderFieldValue = "fieldValue"
        let fixtureBody = FakeRequestBody(foo: "bar")
        let fakeRequest = FakePostNetworkRequest(
            path: fixturePath,
            body: fixtureBody,
            additionalHeaderFields: [fixtureHeaderFieldName: fixtureHeaderFieldValue]
        )

        let urlRequest = sut.build(request: fakeRequest)

        XCTAssertEqual(fixtureBaseUrl.absoluteString + fixturePath, urlRequest?.url?.absoluteString, "Should create proper URL")
        XCTAssertEqual(urlRequest?.httpMethod, "POST", "Should use proper HTTP method")
        XCTAssertEqual(urlRequest?.httpBody, fixtureBody.encoded(), "Should encode request body")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?[fixtureHeaderFieldName], fixtureHeaderFieldValue, "Should contain proper header field")
    }

    func test_whenProvidedWithGetRequestAbstractionWithAbsolutePath_shouldBuildProperGetUrlRequest() {
        let fixtureParamName = "paramName"
        let fixtureParamValue = "paramValue"
        let fixturePath = "https://negturu.com/hello"
        let fixtureCachingPolicy = NSURLRequest.CachePolicy.returnCacheDataDontLoad
        let fakeRequest = FakeGetNetworkRequest(
            path: fixturePath,
            parameters: [fixtureParamName: fixtureParamValue],
            cachePolicy: fixtureCachingPolicy
        )

        let urlRequest = sut.build(request: fakeRequest)

        let expectedPath = "\(fixturePath)?\(fixtureParamName)=\(fixtureParamValue)"
        XCTAssertEqual(urlRequest?.url?.absoluteString, expectedPath, "Should use provided absolute path to create an URL")
        XCTAssertEqual(urlRequest?.httpMethod, "GET", "Should use proper HTTP method")
        XCTAssertEqual(urlRequest?.cachePolicy, fixtureCachingPolicy, "Should use provided cache policy")
        XCTAssertNil(urlRequest?.httpBody, "Should create no body")
    }
}
