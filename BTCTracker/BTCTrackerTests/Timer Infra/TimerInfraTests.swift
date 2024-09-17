import XCTest

final class FoundationTimer {
    private let hertz: Int
    private var timer: Timer?
    private let tick: () -> Void
    private let stopped: () -> Void

    init(hertz: Int = 1, tick: @escaping () -> Void = {}, stopped: @escaping () -> Void) {
        self.hertz = hertz
        self.tick = tick
        self.stopped = stopped
    }

    func start() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1 / Double(hertz), repeats: true, block: { [tick] _ in
            tick()
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        tick()
    }

    func stop() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            stopped()
        }
    }

    deinit {
        stop()
    }
}

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
        exp.expectedFulfillmentCount = 300
        let hertz = 10000

        let sut = makeSUT(hertz: hertz, tick: exp.fulfill)
        sut.start()

        wait(for: [exp], timeout: Double(exp.expectedFulfillmentCount) / Double(hertz) + 0.05)
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
        let hertz = 10000
        let sut = makeSUT(hertz: hertz, tick: {
            tickCount += 1
        }, stopped: stopped.fulfill)

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
