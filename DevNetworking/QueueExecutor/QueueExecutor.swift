//
//  QueueExecutor.swift
//  DevNetworking
//
//  Created by Rahul on 10/06/24.
//

import Foundation

/// An abstraction allowing to execute blocks of code asynchronously.
public protocol QueueExecutor {

    /// Executor type.
    var type: QueueExecutorType { get }

    /// Executes provided code block on predefined execution queue.
    /// - Parameter block: code block to be executed.
    func execute(_ block: @escaping () -> Void)
}

extension QueueExecutor {

    /// - SeeAlso: QueueExecutor.execute()
    public func execute(_ block: @escaping () -> Void) {
        type.queue.async {
            block()
        }
    }
}
