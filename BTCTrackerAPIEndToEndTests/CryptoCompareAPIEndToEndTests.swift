import XCTest
import BTCTracker

final class CryptoCompareAPIEndToEndTests: XCTestCase {

    func test_load_inUS_withUSExtension_loadsValuesSuccessfully() throws {
        let url = URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&e=coinbase")!

        let result = loadResult(from: url)
        switch result {
        case let .success(values):
            let result = try? CryptoCompareExchangeMapper.map(values.0, from: values.1)
            XCTAssertNotNil(result)
        default:
            XCTFail("Expected successful load, got \(result) instead")
        }
    }

    // MARK: - Helpers
    private func loadResult(from url: URL, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(client, file: file, line: line)
        let exp = expectation(description: "Wait for load")

        var capturedResult: HTTPClient.Result!
        client.get(request: .init(url: url)) { result in
            capturedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
        return capturedResult
    }

}
