//
//  FakeAuthenticationTokenProvider.swift
//  DevNetworkingTests
//
//  Created by Rahul on 11/06/24.
//

import Foundation

@testable import DevNetworking

final class FakeAuthenticationTokenProvider: AuthenticationTokenProvider {
    var simulatedAuthenticationToken: String?

    var authenticationToken: String {
        simulatedAuthenticationToken ?? ""
    }
}
