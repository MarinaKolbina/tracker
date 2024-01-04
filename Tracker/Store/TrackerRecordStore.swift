//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerId
    case decodingErrorInvalidDate
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords(_ records: Set<TrackerRecord>)
}

final class TrackerRecordStore: NSObject {
    
    static let shared = TrackerRecordStore()

    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    private var trackerStore = TrackerStore()
    private var completedTrackers: Set<TrackerRecord> = []

    weak var delegate: TrackerRecordStoreDelegate?
    
    override convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.recordId, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.fetchedResultsController = controller
        try controller.performFetch()
    }

    func fetchTrackerRecords() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordsFromCoreData = try context.fetch(fetchRequest)
        return try trackerRecordsFromCoreData.map { try self.trackerRecord(from: $0)}
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord, with tracker: Tracker) throws {
        
        let trackerCoreData = try trackerStore.getTracker(with: tracker.id)
        guard let trackerCoreData = trackerCoreData else {
            print("Tracker not found")
            return
        }
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.recordId = trackerRecord.id.uuidString
        trackerRecordCoreData.tracker = trackerCoreData
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
            throw error
        }
        
    }
    
    func removeTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        do {
            let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
            request.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                            #keyPath(TrackerRecordCoreData.date),
                                            trackerRecord.date as CVarArg,
                                            #keyPath(TrackerRecordCoreData.recordId),
                                            trackerRecord.id.uuidString)
            let records = try context.fetch(request)
            guard let recordToRemove = records.first else { return }
            context.delete(recordToRemove)
            
            try context.save()
        } catch {
            print("Error saving context: \(error)")
            throw error
        }
    }
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let recordId = trackerRecordCoreData.recordId,
              let uuidRecordId = UUID(uuidString: recordId)
        else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        
        return TrackerRecord(id: uuidRecordId,
                             date: date)
    }
    
    func getTrackerRecord(with id: UUID, date: Date) throws -> TrackerRecordCoreData? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        let startOfNextDay = Calendar.current.date(byAdding: components, to: startOfDay)!
        
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "(%K == %@) AND (%K >= %@) AND (%K < %@)",
                                    #keyPath(TrackerRecordCoreData.tracker.trackerId),
                                    id.uuidString,
                                    #keyPath(TrackerRecordCoreData.date),
                                    startOfDay as CVarArg,
                                    #keyPath(TrackerRecordCoreData.date),
                                    startOfNextDay as CVarArg)
        
        let records = try context.fetch(request)
        return records.first
    }
    
    func getTrackerRecordAmount(with tracker: Tracker) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                    #keyPath(TrackerRecordCoreData.tracker.trackerId),
                                    tracker.id.uuidString)
        
        let records = try? context.fetch(request)
        if let records = records {
            return records.count
        } else {
            return 0
        }
    }
}
