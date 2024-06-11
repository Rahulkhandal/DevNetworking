//
//  FakeQueueExecutor.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation

@testable import DevNetworking

final class FakeQueueExecutor: QueueExecutor {
    let type = QueueExecutorType.main

    func execute(_ block: @escaping () -> Void) {
        block()
    }
}

