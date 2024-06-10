//
//  MainQueueExecutor.swift
//  DevNetworking
//
//  Created by Rahul on 10/06/24.
//

import Foundation

/// Default  executor implementation, utilising the Main execution queue.
public final class MainQueueExecutor: QueueExecutor {

    /// - SeeAlso: QueueExecutor.type
    public let type = QueueExecutorType.main

    /// A default, public initializer.
    public init() {}
}
