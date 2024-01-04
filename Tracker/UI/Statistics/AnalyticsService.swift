//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Marina Kolbina on 20/07/2023.
//

import Foundation
import YandexMobileMetrica

enum Events: String {
    case click = "click"
    case open = "open"
    case close = "close"
}

enum Screen: String {
    case main = "Main"
}

enum Items: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}


struct AnalyticsService {
    static func addAppMetrica() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "98d1eec5-c37d-4706-8bbf-c26bda813684") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    
    func reportEvent(event: Events, screen: Screen, item: Items) {
        let params = [
            "screen": screen.rawValue,
            "item" : item.rawValue
        ]
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func reportScreen(event: Events, onScreen: Screen) {
        let params = ["screen" : onScreen.rawValue]
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
}
