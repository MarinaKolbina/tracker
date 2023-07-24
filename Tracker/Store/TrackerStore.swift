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

protocol TrackerStoreProtocol {
    var delegate: TrackerStoreDelegate? { get set}
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws
    func fetchFilteredTrackers(date: Date, searchString: String) throws
    func getTracker(at indexPath: IndexPath) -> Tracker?
    func getTracker(with id: UUID) throws -> TrackerCoreData?
    func getTrackersAmount() -> Int
    func getCategoriesAmount() -> Int
    func getTrackersAmountPerSection(section: Int) -> Int
    func getCategoryLabel(section: Int) -> String
    func changePin(for tracker: Tracker) throws
    func deleteTracker(_ tracker: Tracker) throws
    func updateTracker(_ tracker: Tracker, with newData: Tracker, trackerCategory category: TrackerCategory) throws
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
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
    
    private var trackers: [String: (index: Int, trackers: [Tracker])] {
        var sectionedTrackers: [String: (index: Int, trackers: [Tracker])] = [:]
        
        guard let sections = fetchedResultsController.sections else {
            print("Cannot pull trackers")
            return sectionedTrackers
        }
        
        var pinnedTrackers: [Tracker] = []
        var otherTrackers: [[Tracker]] = []
        var categoryLabels: [String] = []
        
        for sectionInfo in sections {
            var section: [Tracker] = []
            if let objects = sectionInfo.objects as? [TrackerCoreData] {
                for object in objects {
                    if let tracker = try? self.tracker(from: object) {
                        if tracker.isPinned {
                            pinnedTrackers.append(tracker)
                        } else {
                            section.append(tracker)
                        }
                    }
                }
                if !section.isEmpty {
                    otherTrackers.append(section)
                    let categoryLabel = objects.first?.category?.label ?? ""
                    categoryLabels.append(categoryLabel)
                }
            }
        }
        
        var index = 0
        if !pinnedTrackers.isEmpty {
            sectionedTrackers["Закрепленные"] = (index, pinnedTrackers)
            index += 1
        }
        
        for i in 0..<otherTrackers.count {
            sectionedTrackers[categoryLabels[i]] = (index + i, otherTrackers[i])
        }

        return sectionedTrackers
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
                       schedule: scheduleWeekdays,
                       isPinned: trackerCoreData.isPinned
        )
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
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
            trackerCoreData.isPinned = tracker.isPinned
            
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
        for (_, info) in trackers {
            if info.index == indexPath.section {
                return info.trackers[indexPath.item]
            }
        }
        return nil
    }
    
    func getTracker(with id: UUID) throws -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCoreData.trackerId),
                                        id.uuidString)
        let trackers = try context.fetch(request)
        return trackers.first
    }
    
    func getTrackersAmount() -> Int {
        var amount = 0
        for (_, info) in trackers {
            amount += info.trackers.count
        }
        return amount
    }
    
    func getCategoriesAmount() -> Int {
        var amount = 0
        for (_, info) in trackers {
            if !info.trackers.isEmpty {
                amount += 1
            }
        }
        return amount
    }
    
    func getTrackersAmountPerSection(section: Int) -> Int {
        for (_, info) in trackers {
            if info.index == section {
                return info.trackers.count
            }
        }
        return 0
    }
    
    func getCategoryLabel(section: Int) -> String {
        print("Starting to get label for section \(section)")
        for (category, info) in trackers {
            if info.index == section {
                return category
            }
        }
        
        return ""
    }
    
    func changePin(for tracker: Tracker) throws {
        guard let trackerCoreData = try getTracker(with: tracker.id) else {
            print("Tracker not found")
            return
        }
        trackerCoreData.isPinned.toggle()
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        let trackerForDelete = try getTracker(with: tracker.id)
        context.delete(trackerForDelete!)
        try context.save()
    }
    
    func updateTracker(_ tracker: Tracker, with newData: Tracker, trackerCategory category: TrackerCategory) throws {
        let categoryCoreData = try trackerCategoryStore.getTrackerCategory(with: category.id)
        guard let categoryCoreData = categoryCoreData else {
            print("Category not found")
            return
        }
        
        if let trackerCoreData = try getTracker(with: tracker.id) {
            trackerCoreData.colorHex = uiColorMarshalling.hexString(from: newData.color)
            trackerCoreData.emoji = newData.emoji
            trackerCoreData.trackerId = newData.id.uuidString
            trackerCoreData.label = newData.label
            trackerCoreData.isPinned = newData.isPinned
            
            if let schedule = newData.schedule {
                trackerCoreData.schedule = schedule.map{ String($0.day.index) }.joined(separator: ",")
            }
            trackerCoreData.category = categoryCoreData
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
