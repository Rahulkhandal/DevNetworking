//
//  NetworkRequestTypeTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class NetworkRequestTypeTests: XCTestCase {

    func test_everyNetworkRequestType_shouldReturnProperValue() {
        let fixtureType1 = "fixtureType1"
        let fixtureType2 = "fixtureType2"
        let requestTypes = [
            NetworkRequestType.delete, .get, .patch, .post, .put, .custom(fixtureType1), .custom(fixtureType2)
        ]
        let expectedValues = [
            "delete", "get", "patch", "post", "put", fixtureType1, fixtureType2
        ]

        for (index, expectedValue) in expectedValues.enumerated() {
            let requestType = requestTypes[index]
            XCTAssertEqual(requestType.value, expectedValue, "Type \(requestType) should return \(expectedValue) value")
        }
    }
}
