//
//  FakeNetworkModuleAction.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation

@testable import DevNetworking

final class FakeNetworkModuleAction: NetworkModuleAction {
    private(set) var lastRequestPreExecutionActionPerformedOn: URLRequest?
    private(set) var lastResponsePostExecutionActionPerformedOn: NetworkResponse?

    func performBeforeExecutingNetworkRequest(request: NetworkRequest?, urlRequest: inout URLRequest) {
        lastRequestPreExecutionActionPerformedOn = urlRequest
    }

    func performAfterExecutingNetworkRequest(request: NetworkRequest?, networkResponse: NetworkResponse) {
        lastResponsePostExecutionActionPerformedOn = networkResponse
    }
}
