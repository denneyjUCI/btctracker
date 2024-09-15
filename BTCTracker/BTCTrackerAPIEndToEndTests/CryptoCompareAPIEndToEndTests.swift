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

}
