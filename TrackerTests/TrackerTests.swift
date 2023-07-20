//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Marina Kolbina on 18/07/2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewController() {
        let vc = TrackerCollectionViewController()
        let trackers = StubTrackerStore()
        assertSnapshot(matching: vc, as: .image)
    }

}

private class StubTrackerStore: TrackerStoreProtocol {
    
    var delegate: TrackerStoreDelegate?
    
    private static let category = TrackerCategory(label: "Домашний уют")
    
    private static let trackers: [Tracker] = [
            Tracker(
                id: UUID(),
                label: "Поливать растения",
                emoji: "❤️",
                color: .yellow,
                schedule: [.saturday]
//                completedDaysCount: 10,
//                isPinned: true,
//                category: category
            ),
            Tracker(
                id: UUID(),
                label: "Кошка заслонила камеру на созвоне",
                emoji: "😻",
                color: .blue,
                schedule: nil
//                isPinned: false,
//                category: category,
//                completedDaysCount: 2
            ),
            Tracker(
                id: UUID(),
                label: "Бабушка прислала открытку в вотсапе",
                emoji: "🌺",
                color: .green,
                schedule: nil
//                completedDaysCount: 1,
//                isPinned: false,
//                category: category
            )
    ]
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
    }
    
    func fetchFilteredTrackers(date: Date, searchString: String) throws {
    }
    
    func getTracker(at indexPath: IndexPath) -> Tracker? {
        let tracker = StubTrackerStore.trackers[indexPath.item]
        return tracker
    }
    
    func getTracker(with id: UUID) throws -> TrackerCoreData? {
    }
}
