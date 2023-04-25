//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/04/2023.
//

import Foundation
import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidLabel
    case decodingErrorInvalidTrackers
}

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchCategory() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let categoriesFromCoreData = try context.fetch(fetchRequest)
        return try categoriesFromCoreData.map { try self.category(from: $0)}
    }
    
    private func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.label = category.label
        trackerCategoryCoreData.trackers = "category.trackers"
        try context.save()
    }

    private func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let label = trackerCategoryCoreData.label else {
            throw TrackerCategoryStoreError.decodingErrorInvalidLabel
        }
        guard let trackers = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        
        return TrackerCategory(label: label,
                               trackers: [Tracker]())
    }
    
}
