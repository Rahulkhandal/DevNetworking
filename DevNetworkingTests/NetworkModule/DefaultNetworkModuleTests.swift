//
//  DefaultNetworkModuleTests.swift
//  DevNetworkingTests
//
//  Created by Rahul on 10/06/24.
//

import Foundation
import XCTest

@testable import DevNetworking

final class DefaultNetworkModuleTest: XCTestCase {
    var fakeRequestBuilder: FakeRequestBuilder!
    var fakeNetworkSession: FakeNetworkSession!
    var fakeNetworkModuleAction: FakeNetworkModuleAction!
    var fixtureUrlRequest: URLRequest!
    var lastRecordedResponse: NetworkResponse?
    var lastRecordedDecodedResponse: Decodable?
    var lastRecordedError: NetworkError?
    var lastRecordedNetworkTask: URLSessionTask?
    var sut: DefaultNetworkModule!

    override func setUp() {
        fakeRequestBuilder = FakeRequestBuilder()
        fakeNetworkSession = FakeNetworkSession()
        fakeNetworkModuleAction = FakeNetworkModuleAction()
        fixtureUrlRequest = URLRequest(url: URL(string: "https://google.com/welcome")!)
        lastRecordedResponse = nil
        lastRecordedError = nil
        lastRecordedNetworkTask = nil
        lastRecordedDecodedResponse = nil
        sut = DefaultNetworkModule(
            requestBuilder: fakeRequestBuilder,
            urlSession: fakeNetworkSession,
            actions: [fakeNetworkModuleAction],
            completionExecutor: FakeQueueExecutor()
        )
    }

    // MARK: - Handling NetworkRequest:

    func test_withRequestFailsToParse_shouldNotExecute_andReturnProperError() {
        fakeRequestBuilder.simulatedUrlRequest = nil

        perform(request: fakeNetworkRequest)

        XCTAssertEqual(lastRecordedError, NetworkError.requestParsingFailed, "Should return proper error")
        XCTAssertNil(lastRecordedResponse, "Should return no response")
        XCTAssertNil(lastRecordedNetworkTask, "Should not return a task")
    }

    func test_withRequestBuildsProperly_shouldExecuteIt() {
        fakeRequestBuilder.simulatedUrlRequest = fixtureUrlRequest

        perform(request: fakeNetworkRequest)

        XCTAssertEqual(lastRecordedNetworkTask?.state, URLSessionTask.State.running, "Should create a network task")
        XCTAssertEqual(fakeNetworkModuleAction.lastRequestPreExecutionActionPerformedOn, fixtureUrlRequest, "Should execute proper action")
    }

    func test_withNetworkRequest_andSuccessResponseIsReturned_shouldDecodeAndReturnIt() {
        let fixtureResponse = makeURLResponse()
        let fakeDecodedResponse = FakeDecodedResponse(foo: "bar")
        let fakeResponseData = fakeDecodedResponse.encoded()!
        fakeRequestBuilder.simulatedUrlRequest = fixtureUrlRequest

        performAndDecode(request: fakeNetworkRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateSuccess(data: fakeResponseData, response: fixtureResponse)

        let expectedNetworkResponse = NetworkResponse(data: fakeResponseData, networkResponse: fixtureResponse)
        XCTAssertEqual(lastRecordedDecodedResponse as? FakeDecodedResponse, fakeDecodedResponse, "Should decode received data into proper response")
        XCTAssertEqual(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, expectedNetworkResponse, "Should execute proper action")
    }

    func test_withNetworkRequest_andSuccessButNotMatchingResponseIsReturned_shouldReturnProperError() {
        fakeRequestBuilder.simulatedUrlRequest = fixtureUrlRequest

        performAndDecode(request: fakeNetworkRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateSuccess(data: Data(), response: makeURLResponse())

        XCTAssertEqual(lastRecordedError, NetworkError.responseParsingFailed, "Should return a proper error")
    }

    func test_withNetworkRequest_andGenericErrorIsReturned_shouldReturnProperError() {
        let fixtureErrorCode = 420
        let fixtureError = NSError(domain: "fixtureDomain", code: fixtureErrorCode)
        fakeRequestBuilder.simulatedUrlRequest = fixtureUrlRequest

        performAndDecode(request: fakeNetworkRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateFailure(response: makeURLResponse(code: fixtureErrorCode), error: fixtureError)

        XCTAssertEqual(lastRecordedError, NetworkError.invalidRequest(code: fixtureErrorCode, message: fixtureError.localizedDescription), "Should return a proper error")
        XCTAssertNil(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, "Should NOT trigger any post-execution actions")
    }

    // MARK: - Handling UrlRequest:

    func test_withProvidingUrlRequest_shouldExecuteIt() {
        perform(request: fixtureUrlRequest)

        XCTAssertEqual(lastRecordedNetworkTask?.state, URLSessionTask.State.running, "Should create a network task")
        XCTAssertEqual(fakeNetworkModuleAction.lastRequestPreExecutionActionPerformedOn, fixtureUrlRequest, "Should execute proper action")
    }

    func test_withExecutingUrlRequest_andSuccessResponseIsReturned_shouldDecodeAndReturnIt() {
        let fixtureResponse = makeURLResponse()
        let fakeDecodedResponse = FakeDecodedResponse(foo: "bar")
        let fakeResponseData = fakeDecodedResponse.encoded()!

        performAndDecode(request: fixtureUrlRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateSuccess(data: fakeResponseData, response: fixtureResponse)

        let expectedNetworkResponse = NetworkResponse(data: fakeResponseData, networkResponse: fixtureResponse)
        XCTAssertEqual(lastRecordedDecodedResponse as? FakeDecodedResponse, fakeDecodedResponse, "Should decode received data into proper response")
        XCTAssertEqual(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, expectedNetworkResponse, "Should execute proper action")
    }

    func test_withExecutingUrlRequest_andSuccessButNotMatchingResponseIsReturned_shouldReturnProperError() {
        performAndDecode(request: fixtureUrlRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateSuccess(data: Data(), response: makeURLResponse())

        XCTAssertEqual(lastRecordedError, NetworkError.responseParsingFailed, "Should return a proper error")
    }

    func test_withExecutingUrlRequest_andGenericErrorIsReturned_shouldReturnProperError() {
        let fixtureErrorCode = 420
        let fixtureError = NSError(domain: "fixtureDomain", code: fixtureErrorCode)

        performAndDecode(request: fixtureUrlRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateFailure(response: makeURLResponse(code: fixtureErrorCode), error: fixtureError)

        XCTAssertEqual(lastRecordedError, NetworkError.invalidRequest(code: fixtureErrorCode, message: fixtureError.localizedDescription), "Should return a proper error")
        XCTAssertNil(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, "Should NOT trigger any post-execution actions")
    }

    func test_withExecutingUrlRequest_andCancelledErrorIsReturned_shouldNotReturnAnything() {
        let fixtureError = NSError(domain: "fixtureDomain", code: -999)

        performAndDecode(request: fixtureUrlRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateFailure(response: nil, error: fixtureError)

        XCTAssertNil(lastRecordedError, "Should return no error")
        XCTAssertNil(lastRecordedDecodedResponse, "Should return no response")
        XCTAssertEqual(fakeNetworkModuleAction.lastRequestPreExecutionActionPerformedOn, fixtureUrlRequest, "Should execute proper per-execution action")
        XCTAssertNil(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, "Should NOT trigger any post-execution actions")
    }

    func test_withExecutingUrlRequest_andResponseWithErrorIsReturned_shouldReturnProperError() {
        let fixtureErrorCode = 420

        performAndDecode(request: fixtureUrlRequest, responseType: FakeDecodedResponse.self)
        fakeNetworkSession.simulateFailure(response: makeURLResponse(code: fixtureErrorCode), error: nil)

        let expectedErrorMessage = HTTPURLResponse.localizedString(forStatusCode: fixtureErrorCode)
        XCTAssertEqual(lastRecordedError, NetworkError.invalidRequest(code: fixtureErrorCode, message: expectedErrorMessage), "Should return a proper error")
        XCTAssertNil(fakeNetworkModuleAction.lastResponsePostExecutionActionPerformedOn, "Should NOT trigger any post-execution actions")
    }
}

extension DefaultNetworkModuleTest {

    var fakeNetworkRequest: FakeGetNetworkRequest {
        FakeGetNetworkRequest(path: "/welcome")
    }

    func makeURLResponse(url: URL? = nil, code: Int = 200) -> HTTPURLResponse {
        let url = url ?? fixtureUrlRequest.url!
        return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    func perform(request: NetworkRequest) {
        lastRecordedNetworkTask = sut.perform(request: request) { result in
            switch result {
            case let .success(response):
                self.lastRecordedResponse = response
            case let .failure(error):
                self.lastRecordedError = error
            }
        }
    }

    func perform(request: URLRequest) {
        lastRecordedNetworkTask = sut.perform(urlRequest: request) { result in
            switch result {
            case let .success(response):
                self.lastRecordedResponse = response
            case let .failure(error):
                self.lastRecordedError = error
            }
        }
    }

    func performAndDecode<T: Decodable>(request: NetworkRequest, responseType: T.Type) {
        lastRecordedNetworkTask = sut.performAndDecode(request: request, responseType: T.self) { result in
            switch result {
            case let .success(response):
                self.lastRecordedDecodedResponse = response
            case let .failure(error):
                self.lastRecordedError = error
            }
        }
    }

    func performAndDecode<T: Decodable>(request: URLRequest, responseType: T.Type) {
        lastRecordedNetworkTask = sut.performAndDecode(urlRequest: request, responseType: T.self) { result in
            switch result {
            case let .success(response):
                self.lastRecordedDecodedResponse = response
            case let .failure(error):
                self.lastRecordedError = error
            }
        }
    }
}

private struct FakeDecodedResponse: Codable, Equatable {
    let foo: String
}
