import XCTest

final class FoundationTimer {
    private let timer: Timer
    private let tick: () -> Void
    init(hertz: Int = 1, tick: @escaping () -> Void = {}) {
        self.tick = tick
        timer = Timer.scheduledTimer(withTimeInterval: 1 / Double(hertz), repeats: true, block: { _ in
            tick()
        })
    }

    func start() {
        RunLoop.main.add(timer, forMode: .common)
        tick()
    }
}

final class TimerInfraTests: XCTestCase {

    func test_init_doesNotSendTick() {
        let tickCount = 0

        let _ = FoundationTimer()

        XCTAssertEqual(tickCount, 0)
    }

    func test_start_sendsTick() {
        var tickCount = 0
        let sut = FoundationTimer(tick: { tickCount += 1})

        sut.start()

        XCTAssertEqual(tickCount, 1)
    }

    func test_start_sendsTickAtInterval() {
        var tickCount = 0
        let exp = expectation(description: "wait for tick")
        exp.expectedFulfillmentCount = 2

        let sut = FoundationTimer(hertz: 1000, tick: {
            tickCount += 1
            exp.fulfill()
        })
        sut.start()

        wait(for: [exp], timeout: 0.1)

        XCTAssertEqual(tickCount, 2)
    }

}
