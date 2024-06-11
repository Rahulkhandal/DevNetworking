//
//  AddAuthenticationTokenNetworkModuleActionTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 11/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class AddAuthenticationTokenNetworkModuleActionTests: XCTestCase {
    let fixtureAuthenticationTokenHeaderFieldName = "Authentication"
    var fakeAuthenticationTokenProvider: FakeAuthenticationTokenProvider!
    var sut: AddAuthenticationTokenNetworkModuleAction!

    override func setUp() {
        fakeAuthenticationTokenProvider = FakeAuthenticationTokenProvider()
        sut = AddAuthenticationTokenNetworkModuleAction(
            authenticationTokenProvider: fakeAuthenticationTokenProvider,
            authenticationTokenHeaderFieldName: fixtureAuthenticationTokenHeaderFieldName
        )
    }

    func test_whenExecutedWithRequestRequiringAuthentication_shouldAddAccessTokenValueAsHeaderField() {
        
        let fixtureAuthenticationToken = "AuthToken"
        let fakeRequest = FakeGetNetworkRequest(path: "/welcome", requiresAuthenticationToken: true)
        var fixtureUrlRequest = URLRequest(url: URL(string: "https://google.com/")!)
        fakeAuthenticationTokenProvider.simulatedAuthenticationToken = fixtureAuthenticationToken

        sut.performBeforeExecutingNetworkRequest(request: fakeRequest, urlRequest: &fixtureUrlRequest)

        let authenticationFieldValue = fixtureUrlRequest.allHTTPHeaderFields?[fixtureAuthenticationTokenHeaderFieldName]
        XCTAssertEqual(authenticationFieldValue, fixtureAuthenticationToken, "Should contain proper header field")
    }

    func test_whenExecutedWithRequestNotRequiringAuthentication_shouldNotAddAccessTokenValueAsHeaderField() {
        let fixtureAuthenticationToken = "AuthToken"
        let fakeRequest = FakeGetNetworkRequest(path: "/welcome", requiresAuthenticationToken: false)
        var fixtureUrlRequest = URLRequest(url: URL(string: "https://google.com/")!)
        let initialUrlRequest = fixtureUrlRequest
        fakeAuthenticationTokenProvider.simulatedAuthenticationToken = fixtureAuthenticationToken

        sut.performBeforeExecutingNetworkRequest(request: fakeRequest, urlRequest: &fixtureUrlRequest)

        XCTAssertEqual(initialUrlRequest, fixtureUrlRequest, "Should not modify the request")
    }
}
