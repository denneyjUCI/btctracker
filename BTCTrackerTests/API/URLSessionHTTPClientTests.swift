import XCTest

final class URLSessionHTTPClient {
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    func get(request: URLRequest, completion: @escaping (Error?) -> Void = { _ in }) {
        session.dataTask(with: request, completionHandler: { _, _, error in
            if let error = error {
                completion(error)
            } else {
                completion(UnexpectedValuesRepresentation())
            }
        }).resume()
    }
}

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

        makeSUT().get(request: request)

        wait(for: [exp], timeout: 1)
    }

    func test_getRequest_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as? NSError

        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }

    func test_getRequest_failsOnAllUnexpectedValuesRepresentations() {
        let anyData = Data("any".utf8)
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: nil))
    }

    // MARK: - Helpers
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error? = nil) -> Error? {
        let exp = expectation(description: "wait for request")
        URLProtocolStub.stub(data: data, response: response, error: error)

        var capturedError: Error?
        makeSUT().get(request: anyURLRequest()) { error in
            capturedError = error
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
        return capturedError
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
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

    private func trackForMemoryLeaks(_ object: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Object should have been deallocated, possible memory leak!", file: file, line: line)
        }
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
