//
//  BackgroundQueueExecutorTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class BackgroundQueueExecutorTests: XCTestCase {
    var sut: BackgroundQueueExecutor!

    override func setUp() {
        sut = BackgroundQueueExecutor()
    }

    func test_shouldExecuteCallbackAsynchronously() {
    
        let expectation = XCTestExpectation(description: "Execute callback")
        var didExecuteCallback: Bool?

        sut.execute {
            didExecuteCallback = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.type, QueueExecutorType.backgroundConcurrent, "Should be of proper type")
        XCTAssertEqual(didExecuteCallback, true, "Should execute callback")
    }
}
