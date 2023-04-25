//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import Foundation
import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerId
    case decodingErrorInvalidDate
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchTrackerRecords() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordsFromCoreData = try context.fetch(fetchRequest)
        return try trackerRecordsFromCoreData.map { try self.trackerRecord(from: $0)}
    }
    
    private func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = trackerRecord.trackerId
        trackerRecordCoreData.date = Date()
        try context.save()
    }
    
    private func removeTrackerRecord() {
        try context.delete(trackerRecordCoreData)
    }
    
    private func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerId = trackerRecordCoreData.trackerId else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        
        return TrackerRecord(trackerId: trackerId,
                            date: Date())
    }
}

