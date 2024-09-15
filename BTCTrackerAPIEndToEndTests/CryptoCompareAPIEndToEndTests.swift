import XCTest
import BTCTracker

final class CryptoCompareAPIEndToEndTests: XCTestCase {

    func test_load_inUS_withMainURL_doesNotLoadValuesSuccessfully() throws {
        let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")!

        let result = loadResult(from: url)
        switch result {
        case let .success(values):
            let result = try? BinanceExchangeMapper.map(values.0, from: values.1)
            XCTAssertNil(result)
        default:
            XCTFail("Expected successful load, got \(result) instead")
        }
    }

    func test_load_inUS_withUSExtension_loadsValuesSuccessfully() throws {
        let url = URL(string: "https://api.binance.us/api/v3/ticker/price?symbol=BTCUSDT")!

        let result = loadResult(from: url)
        switch result {
        case let .success(values):
            let result = try? BinanceExchangeMapper.map(values.0, from: values.1)
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
