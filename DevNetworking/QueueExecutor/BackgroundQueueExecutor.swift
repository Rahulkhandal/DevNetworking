//
//  BackgroundQueueExecutor.swift
//  DevNetworking
//
//  Created by Rahul on 10/06/24.
//

import Foundation

/// Default  executor implementation, utilising concurrent background execution queue.
public final class BackgroundQueueExecutor: QueueExecutor {

    /// - SeeAlso: QueueExecutor..type
    public let type = QueueExecutorType.backgroundConcurrent

    /// A default, public initializer.
    public init() {}
}
