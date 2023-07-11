//
//  TrackerStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import UIKit
import CoreData

enum TrackerStoreError: Error { //перечисление для представления ошибок декодирования
    case decodingErrorInvalidColorHex
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidId
    case decodingErrorInvalidLabel
    case decodingErrorInvalidSchedule
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private var trackerCategoryStore = TrackerCategoryStore()
    weak var delegate: TrackerStoreDelegate?
    
    convenience override init() { //получает контекст управляемого объекта от общего UIApplication делегата и вызывает второй инициализатор
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws { //устанавливает стек Core Data, выполняет первоначальную выборку и выбирает контроллер выборки.
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.schedule, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else {
            print("Cannot pull trackers")
            return []
        }
        print(trackers)
        return trackers
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        do {
            let categoryCoreData = try trackerCategoryStore.getTrackerCategory(with: category.id)
            guard let categoryCoreData = categoryCoreData else {
                print("Category not found")
                return
            }
            
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.colorHex = uiColorMarshalling.hexString(from: tracker.color)
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.trackerId = tracker.id.uuidString
            trackerCoreData.label = tracker.label
            
            if let schedule = tracker.schedule {
                trackerCoreData.schedule = schedule.map{ String($0.day.index) }.joined(separator: ",")
            }
            
            trackerCoreData.category = categoryCoreData
            
            try context.save()
        } catch {
            print("Error saving context: \(error)")
            throw error
        }
    }
    
    func fetchFilteredTrackers(date: Date, searchString: String) throws {
        var predicates: [NSPredicate] = []
        
        // weekday predicate
        guard let previosDayNumber = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
            return
        }
        
        let weekday = String(Calendar.current.component(.weekday, from: previosDayNumber))
        let weekdayPredicate = NSPredicate(format: "%K == nil OR %K CONTAINS[c] %@",
                                           #keyPath(TrackerCoreData.schedule),
                                           #keyPath(TrackerCoreData.schedule),
                                           weekday)
        predicates.append(weekdayPredicate)
  
        // searchBar predicate
        if !searchString.isEmpty {
            let searchBarPredicate = NSPredicate(format: "%K CONTAINS[c] %@",
                                                 #keyPath(TrackerCoreData.label),
                                                 searchString)
            predicates.append(searchBarPredicate)
        }

        // predicates applying
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Cannot get filtered trackers \(error)")
        }
        
        delegate?.didUpdate()
    }
    
    func getTracker(at indexPath: IndexPath) -> Tracker? {
        do {
            return try tracker(from: fetchedResultsController.object(at: indexPath))
        } catch {
            return nil
        }
    }
    
    func getTracker(with id: UUID) throws -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCoreData.trackerId),
                                        id.uuidString)
        let trackers = try context.fetch(request)
        return trackers.first
    }
    
    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let colorHex = trackerCoreData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColorHex
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmojies
        }
        guard let trackerId = trackerCoreData.trackerId,
              let uuidTrackerId = UUID(uuidString: trackerId)
        else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let label = trackerCoreData.label else {
            throw TrackerStoreError.decodingErrorInvalidLabel
        }
        guard let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        let intArray = schedule.components(separatedBy: ",").map { Int($0) }
        
        var scheduleWeekdays: [Weekday] = []
        
        for i in intArray {
            for k in Weekday.allCases {
                if k.day.index == i {
                    scheduleWeekdays.append(k)
                }
            }
        }
        
        
        return Tracker(id: uuidTrackerId,
                       label: label,
                       emoji: emoji,
                       color: uiColorMarshalling.color(from: colorHex),
                       schedule: scheduleWeekdays
                )
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
