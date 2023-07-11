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
    var trackersCategories: [TrackerCategory] { get }
    
    func getTrackerCategory(with id: UUID) throws -> TrackerCategoryCoreData?
    func getTrackerCategory(at indexPath: IndexPath) -> TrackerCategory?
    func addNewCategory(_ category: TrackerCategory) throws
    var delegate: TrackerCategoryStoreDelegate? { get set }
    func deleteCategory(_ category: TrackerCategory) throws
    func fetchCategory() throws -> [TrackerCategory] 
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    weak var delegate: TrackerCategoryStoreDelegate?


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
        controller.delegate = self
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
    
    func fetchCategory() throws -> [TrackerCategory] {
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
    
    func deleteCategory(_ category: TrackerCategory) throws {
        let categoryForDelete = try getTrackerCategory(with: category.id)
        context.delete(categoryForDelete!)
        try context.save()
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
    
    func getTrackerCategory(at indexPath: IndexPath) -> TrackerCategory? {
        do {
            return try category(from: fetchedResultsController.object(at: indexPath))
        } catch {
            return nil
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
