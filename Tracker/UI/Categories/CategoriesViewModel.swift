//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Marina Kolbina on 06/07/2023.
//

import UIKit

final class CategoriesViewModel {
    
    private var trackerCategoryStore: TrackerCategoryStoreProtocol
    
    private(set) var selectedCategory: TrackerCategory? = nil
    
    init(trackerCategoryStore: TrackerCategoryStoreProtocol) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
    }
    
    func countCategories() -> Int {
        trackerCategoryStore.trackersCategories.count
    }
    
    func getCategory(at indexPath: IndexPath) -> TrackerCategory? {
        trackerCategoryStore.getTrackerCategory(at: indexPath)
    }
    
    func addNewCategory(_ category: TrackerCategory) {
        try? trackerCategoryStore.addNewCategory(category)
    }
    
//    func takeAllCategories() throws -> [TrackerCategory] {
//        try! trackerCategoryStore.fetchCategory()
//    }
    
    
    func deleteCategory(_ category: TrackerCategory) {
        try? trackerCategoryStore.deleteCategory(category)
    }
    
    
    func selectCategory(indexPath: IndexPath) {
        selectedCategory = trackerCategoryStore.trackersCategories[indexPath.row]
    }
    
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func didUpdate() {
        trackerCategoryStore.trackersCategories
    }
}
