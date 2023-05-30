//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidLabel
    case decodingErrorInvalidCategoryId
}

protocol TrackerCategoryStoreProtocol {
    func getTrackerCategory(with id: UUID) throws -> TrackerCategoryCoreData?
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws { //устанавливает стек Core Data, выполняет первоначальную выборку и выбирает контроллер выборки.
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.label, ascending: true) //по нему ли сортировать?
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
    
    var trackersCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackersCategories = try? objects.map({ try self.category(from: $0) })
        else {
            print("Cannot pull categories")
            return []
        }
        return trackersCategories
    }
    
    private func fetchCategory() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let categoriesFromCoreData = try context.fetch(fetchRequest)
        return try categoriesFromCoreData.map { try self.category(from: $0)}
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.label = category.label
        trackerCategoryCoreData.categoryId = category.id.uuidString
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
            throw error
        }
    }

    private func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let label = trackerCategoryCoreData.label else {
            throw TrackerCategoryStoreError.decodingErrorInvalidLabel
        }
        guard let categoryId = trackerCategoryCoreData.categoryId,
              let uuidTrackerCategoryId = UUID(uuidString: categoryId)
        else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryId
        }
        
        return TrackerCategory(id: uuidTrackerCategoryId,
                               label: label)
    }
    
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func getTrackerCategory(with id: UUID) throws -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryCoreData.categoryId),
                                        id.uuidString)
        let categories = try context.fetch(request)
        return categories.first
    }
}
