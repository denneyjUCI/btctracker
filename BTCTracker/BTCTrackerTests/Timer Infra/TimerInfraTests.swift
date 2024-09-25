import XCTest
import BTCTracker

final class TimerInfraTests: XCTestCase {

    func test_start_sendsTick() {
        var tickCount = 0
        let sut = makeSUT()

        _ = sut.start(tick: { tickCount += 1 })

        XCTAssertEqual(tickCount, 1)
    }

    func test_start_sendsTickAtInterval() {
        let exp = expectation(description: "wait for ticks")
        exp.expectedFulfillmentCount = 10
        let hertz = 300

        let sut = makeSUT(hertz: hertz)
        _ = sut.start(tick: exp.fulfill)

        wait(for: [exp], timeout: Double(exp.expectedFulfillmentCount) / Double(hertz) + 0.1)
    }

    func test_cancel_afterStart_doesNotSendTick() {
        var tickCount = 0
        let sut = makeSUT()

        let cancellable = sut.start(tick: { tickCount += 1 })
        cancellable.cancel()

        XCTAssertEqual(tickCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(
        hertz: Int = 1000,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> FoundationTimer {
        let sut = FoundationTimer(hertz: hertz)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
