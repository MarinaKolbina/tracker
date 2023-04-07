//
//  TabBarController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create two view controllers to display in the tab bar
        let firstVC = TrackerCollectionViewController()
        firstVC.view.backgroundColor = .white
        firstVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackersIcon"), tag: 0)
        
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .white
        secondVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticsIcon"), tag: 1)
        
        // Set the view controllers to display in the tab bar
        viewControllers = [firstVC, secondVC]
    }
}
