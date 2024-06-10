//
//  QueueExecutorType.swift
//  DevNetworking
//
//  Created by Rahul on 10/06/24.
//

import Foundation

/// An enumeration describing properties of an executor queue.
public enum QueueExecutorType: Equatable {

    /// Main queue.
    case main

    /// Background, concurrent queue.
    case backgroundConcurrent
}

public extension QueueExecutorType {

    /// A convenience field creating a queue based on an executor type.
    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .backgroundConcurrent:
            return DispatchQueue(label: "ExecutorBackgroundQueue", attributes: .concurrent)
        }
    }
}
