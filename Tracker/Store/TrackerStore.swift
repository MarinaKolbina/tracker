//
//  TrackerStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidColorHex
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidId
    case decodingErrorInvalidLabel
    case decodingErrorInvalidSchedule
}

final class TrackerStore {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = TrackerCoreData.fetchRequest()
        let trackersFromCoreData = try context.fetch(fetchRequest)
        return try trackersFromCoreData.map { try self.tracker(from: $0)}
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.label = tracker.label
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.colorHex = uiColorMarshalling.hexString(from: tracker.color)
//        trackerCoreData.schedule = "Weekday.monday"
        try context.save()
    }
    
    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let colorHex = trackerCoreData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColorHex
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmojies
        }
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let label = trackerCoreData.label else {
            throw TrackerStoreError.decodingErrorInvalidLabel
        }
        guard let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(id: id,
                       label: label,
                       emoji: emoji,
                       color: uiColorMarshalling.color(from: colorHex),
                       schedule: [Weekday.monday])
    }
}
