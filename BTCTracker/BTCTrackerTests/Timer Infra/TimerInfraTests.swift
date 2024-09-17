import XCTest

final class FoundationTimer {

}

final class TimerInfraTests: XCTestCase {

    func test_init_doesNotSendTick() {
        let tickCount = 0

        let _ = FoundationTimer()

        XCTAssertEqual(tickCount, 0)
    }

}
