//
//  NetworkResponse.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class NetworkResponseTests: XCTestCase {
    private let fakeResponseData = FakeResponseData(fooString: "bar", fooNumber: 1)
    var fixtureHTTPURLResponse: HTTPURLResponse!
    var lastDecodedData: Codable?
    var lastReceivedError: NetworkError?
    var sut: NetworkResponse!

    override func setUp() {
        lastDecodedData = nil
        lastReceivedError = nil
        fixtureHTTPURLResponse = HTTPURLResponse(
            url: URL(string: "https://google.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
    }

    func test_withNetworkResponseValidData_shouldDecodeItToAssociatedItem() {
        
        sut = NetworkResponse(data: fakeResponseData.encoded(), networkResponse: fixtureHTTPURLResponse)

        decodeResponse(into: FakeResponseData.self)

        XCTAssertEqual(lastDecodedData as? FakeResponseData, fakeResponseData, "Should properly decode received data")
        XCTAssertNil(lastReceivedError, "Should not return an error")
    }

    func test_withNetworkResponseWithoutData_shouldReturnProperError() {
        
        sut = NetworkResponse(data: nil, networkResponse: fixtureHTTPURLResponse)

        decodeResponse(into: FakeResponseData.self)

        XCTAssertNil(lastDecodedData, "Should not be able to decode data")
        XCTAssertEqual(lastReceivedError, NetworkError.noResponseData, "Should return a proper error")
    }

    func test_withNetworkResponseInvalidData_shouldReturnProperError() {
        
        sut = NetworkResponse(data: Data(), networkResponse: fixtureHTTPURLResponse)

        decodeResponse(into: FakeResponseData.self)

        XCTAssertNil(lastDecodedData, "Should not be able to decode data")
        XCTAssertEqual(lastReceivedError, NetworkError.responseParsingFailed, "Should return a proper error")
    }
}

private extension NetworkResponseTests {

    func decodeResponse<T: Codable>(into type: T.Type) {
        let decoded = sut.decoded(into: type)
        switch decoded {
        case let .success(decoded):
            lastDecodedData = decoded
        case let .failure(error):
            lastReceivedError = error
        }
    }
}

private struct FakeResponseData: Codable, Equatable {
    let fooString: String
    let fooNumber: Int
}

