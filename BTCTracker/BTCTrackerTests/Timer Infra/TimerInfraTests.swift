import XCTest
import BTCTracker

final class TimerInfraTests: XCTestCase {

    func test_init_doesNotSendTick() {
        var tickCount = 0
        let _ = makeSUT(tick: { tickCount += 1 })

        XCTAssertEqual(tickCount, 0)
    }

    func test_start_sendsTick() {
        var tickCount = 0
        let sut = makeSUT(tick: { tickCount += 1 })

        sut.start()

        XCTAssertEqual(tickCount, 1)
    }

    func test_start_sendsTickAtInterval() {
        let exp = expectation(description: "wait for ticks")
        exp.expectedFulfillmentCount = 10
        let hertz = 300

        let sut = makeSUT(hertz: hertz, tick: exp.fulfill)
        sut.start()

        wait(for: [exp], timeout: Double(exp.expectedFulfillmentCount) / Double(hertz) + 0.1)
    }

    func test_stop_doesNotSendTick() {
        var tickCount = 0
        let sut = makeSUT(tick: { tickCount += 1 })
        sut.stop()

        XCTAssertEqual(tickCount, 0)
    }

    func test_stop_afterStart_doesNotSendTick() {
        var tickCount = 0
        let stopped = expectation(description: "wait for stop")
        let sut = makeSUT(tick: { tickCount += 1 }, stopped: stopped.fulfill)

        sut.start()
        sut.stop()

        wait(for: [stopped], timeout: 0.05)

        XCTAssertEqual(tickCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(
        hertz: Int = 1000,
        tick: @escaping () -> Void,
        stopped: @escaping () -> Void = { },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> FoundationTimer {
        let sut = FoundationTimer(hertz: hertz, tick: tick, stopped: stopped)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
