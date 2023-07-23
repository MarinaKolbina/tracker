//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/07/2023.
//

import UIKit

enum StatisticsCases: CaseIterable, CustomStringConvertible {
    case bestPeriod
    case perfectDays
    case completedTrackers
    case mediumValue
    
    var description: String {
        switch self {
        case .bestPeriod:
            return "Лучший период"
        case .perfectDays:
            return "Идеальные дни"
        case .completedTrackers:
            return "Завершенные трекеры"
        case .mediumValue:
            return "Среднее значение"
        }
    }
}


final class StatisticsViewModel {
    
    // MARK: - Properties
    
    private let trackerRecordStore = TrackerRecordStore.shared
    
    var cellModels: [StatisticsCellModel] = {
        var result = [StatisticsCellModel]()
        for item in StatisticsCases.allCases {
            let model = StatisticsCellModel(value: "0", description: item.description)
            result.append(model)
        }
        return result
    }()
   
    // MARK: - Observables
   
    @Observable
    private (set) var bestPeriod: Int = 0
    
    @Observable
    private (set) var perfectDays: Int = 0
    
    @Observable
    private (set) var completedTrackers: Int = 0
    
    @Observable
    private (set) var mediumValue: Int = 0
    
    @Observable
    private (set) var statusEmptyImage: Bool = true
    
    //   MARK: - Methods
    
    func startObserve() {
        observeBestPeriod()
        observePerfectDays()
        observeCompletedTrackers()
        observeMediumValue()
        checkIsStatisticsEmpty()
    }
    
    
    private func observeBestPeriod() {
        
    }
    
    private func observePerfectDays() {
        
    }
    
    private func observeCompletedTrackers() {
        var amount = 0
        if let trackerRecords = try? trackerRecordStore.fetchTrackerRecords() {
            amount = trackerRecords.count
        } else {}
        print("observer on tracker records \(amount)")
        completedTrackers = amount
    }
    
    private func observeMediumValue() {
        
    }
    
    private func checkIsStatisticsEmpty() {
        statusEmptyImage = bestPeriod == 0 && perfectDays == 0 && completedTrackers == 0 && mediumValue == 0
    }
}
