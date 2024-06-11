//
//  MainQueueExecutorTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class MainQueueExecutorTests: XCTestCase {
    var sut: MainQueueExecutor!

    override func setUp() {
        sut = MainQueueExecutor()
    }

    func test_shouldExecuteCallbackAsynchronously() {
        
        let expectation = XCTestExpectation(description: "Execute a callback")
        var didExecuteCallback: Bool?

        sut.execute {
            didExecuteCallback = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.type, QueueExecutorType.main, "Should be of proper type")
        XCTAssertEqual(didExecuteCallback, true, "Should execute callback")
    }
}
