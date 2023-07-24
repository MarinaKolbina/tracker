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
 
    
    func testViewControllerLight() {
        let vc = TrackerCollectionViewController(trackerStore: StubTrackerStore())
        vc.view.backgroundColor = .white
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDark() {
        let vc = TrackerCollectionViewController(trackerStore: StubTrackerStore())
        vc.view.backgroundColor = .black
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
 
private class StubTrackerStore: TrackerStoreProtocol {
    func getTrackersAmount() -> Int {
        3
    }
    
    func getCategoriesAmount() -> Int {
        2
    }
    
    func getTrackersAmountPerSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func getCategoryLabel(section: Int) -> String {
        switch section {
        case 0:
            return "Закрепленные"
        case 1:
            return "Домашний уют"
        default:
            return ""
        }
    }
    
    var delegate: TrackerStoreDelegate?
    
    var trackers: [[Tracker]] = [
            [Tracker(
                id: UUID(),
                label: "Поливать растения",
                emoji: "❤️",
                color: .red,
                schedule: [.saturday]
            )],
            [Tracker(
                id: UUID(),
                label: "Кошка заслонила камеру на созвоне",
                emoji: "😻",
                color: .blue,
                schedule: nil
            ),
            Tracker(
                id: UUID(),
                label: "Бабушка прислала открытку в вотсапе",
                emoji: "🌺",
                color: .green,
                schedule: nil
            )]
    ]
 
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {}
 
    func fetchFilteredTrackers(date: Date, searchString: String) throws {}
 
    func getTracker(at indexPath: IndexPath) -> Tracker? {
        let tracker = trackers[indexPath.section][indexPath.item]
        return tracker
    }
 
    func getTracker(with id: UUID) throws -> TrackerCoreData? { return nil }
    
    func changePin(for tracker: Tracker) throws {}
    
    func deleteTracker(_ tracker: Tracker) throws {}
    
    func updateTracker(_ tracker: Tracker, with newData: Tracker, trackerCategory category: TrackerCategory) throws {}
}
 
