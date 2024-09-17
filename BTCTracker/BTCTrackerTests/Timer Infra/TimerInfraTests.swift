import XCTest

final class FoundationTimer {
    private let tick: () -> Void
    init(tick: @escaping () -> Void = {}) {
        self.tick = tick
    }

    func start() {
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

}
