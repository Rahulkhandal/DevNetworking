//
//  NetworkErrorConvertibleTest.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class NetworkErrorConvertibleTests: XCTestCase {
    var sut: NetworkErrorConvertible!

    func test_withCorrectErrorCodeAndMessage_shouldCreateProperNetworkError() {
        
        let fixtureStatusCode = 480
        let fixtureMessage = "fixtureMessage"

        sut = fixtureStatusCode
        let error = sut.toNetworkError(message: fixtureMessage)

        XCTAssertEqual(error, NetworkError.invalidRequest(code: fixtureStatusCode, message: fixtureMessage), "Should create proper error")
    }

    func test_withIncorrectErrorCode_shouldNotCreateNetworkError() {

        let fixtureStatusCode = 200

        sut = fixtureStatusCode
        let error = sut.toNetworkError()

        XCTAssertNil(error, "Should not create an error")
    }
}
