import XCTest
import BTCTracker

final class BinanceAPIEndToEndTests: XCTestCase {

    func test_load_inUS_withMainURL_doesNotLoadValuesSuccessfully() throws {
        let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")!

        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let exp = expectation(description: "Wait for load")

        client.get(request: .init(url: url)) { result in
            switch result {
            case let .success(values):
                let result = try? BinanceExchangeMapper.map(values.0, from: values.1)
                XCTAssertNil(result)
            default:
                XCTFail("Expected successful load, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

    func test_load_inUS_withUSExtension_loadsValuesSuccessfully() throws {
        let url = URL(string: "https://api.binance.us/api/v3/ticker/price?symbol=BTCUSDT")!

        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let exp = expectation(description: "Wait for load")

        client.get(request: .init(url: url)) { result in
            switch result {
            case let .success(values):
                let result = try? BinanceExchangeMapper.map(values.0, from: values.1)
                XCTAssertNotNil(result)
            default:
                XCTFail("Expected successful load, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
    }

}
