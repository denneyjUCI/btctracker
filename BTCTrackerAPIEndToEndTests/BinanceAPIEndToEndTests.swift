import XCTest
import BTCTracker

final class BinanceAPIEndToEndTests: XCTestCase {

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

}
