//
//  NetworkSession.swift
//  DevNetworking
//
//  Created by Rahul on 07/06/24.
//

/// Convenience wrapper for Foundation URL Session.
///  helpfull in mocking and implementing protocol oriented
public protocol NetworkSession: AnyObject {

    /// Creates a URL session data task.
    ///
    /// - Parameters:
    ///   - request: an URL request.
    ///   - completionHandler: a request completion callback.
    /// - Returns: an URL data task.
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: NetworkSession {}
