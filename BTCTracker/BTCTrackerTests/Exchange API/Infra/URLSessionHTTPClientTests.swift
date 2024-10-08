import XCTest
import BTCTracker

final class URLSessionHTTPClientTests: XCTestCase {

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.removeStub()
    }

    func test_getRequest_performsGETRequestWithProvidedRequest() throws {
        let request = anyURLRequest()
        let exp = expectation(description: "wait for request")
        URLProtocolStub.observeRequests { req in
            XCTAssertEqual(req.url, request.url)
            XCTAssertEqual(req.httpMethod, request.httpMethod)
            exp.fulfill()
        }

        makeSUT().get(request: request) { _ in }

        wait(for: [exp], timeout: 1)
    }

    func test_getRequest_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as? NSError

        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }

    func test_getRequest_failsOnAllUnexpectedValuesRepresentations() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }

    func test_getRequest_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let values = resultValuesFor(data: data, response: response, error: nil)

        XCTAssertEqual(values?.data, data)
        assertResponsesEqual(values?.response, response)
    }

    func test_getRequest_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let emptyData = Data()
        let response = anyHTTPURLResponse()

        let values = resultValuesFor(data: nil, response: response, error: nil)

        XCTAssertEqual(values?.data, emptyData)
        assertResponsesEqual(values?.response, response)
    }

    // MARK: - Helpers
    private func assertResponsesEqual(_ lhs: HTTPURLResponse?, _ rhs: HTTPURLResponse, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(lhs?.url, rhs.url, file: file, line: line)
        XCTAssertEqual(lhs?.statusCode, rhs.statusCode, file: file, line: line)
    }

    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error? = nil, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected error for \(String(describing: data)), \(String(describing: response)), \(String(describing: error)), got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(data: data, response: response, error: error)
        switch result {
        case let .success(values):
            return values
        default:
            XCTFail("Expected values for \(String(describing: data)), \(String(describing: response)), \(String(describing: error)), got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(data: Data?, response: URLResponse?, error: Error?) -> HTTPClient.Result {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let exp = expectation(description: "wait for request")

        var capturedResult: HTTPClient.Result!
        makeSUT().get(request: anyURLRequest()) { result in
            capturedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        return capturedResult
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func anyData() -> Data {
        Data("any".utf8)
    }

    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: -1)
    }

    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }

    private func anyURLRequest() -> URLRequest {
        URLRequest(url: anyURL())
    }

    private class URLProtocolStub: URLProtocol {
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
            let requestObserver: ((URLRequest) -> Void)?
        }

        private static var _stub: Stub?
        private static var stub: Stub? {
            get { queue.sync { _stub } }
            set { queue.sync { _stub = newValue }}
        }

        private static var queue = DispatchQueue(label: "URLProtocolStub.queue")

        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error, requestObserver: nil)
        }

        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
        }

        static func removeStub() {
            stub = nil
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }

            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }

            stub.requestObserver?(request)
        }

        override func stopLoading() {}

    }
}
