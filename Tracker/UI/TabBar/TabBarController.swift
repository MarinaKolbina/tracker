//
//  TabBarController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//
 
import Foundation
import UIKit
 
final class TabBarController: UITabBarController {
    
    let trackersMenu = NSLocalizedString("trackers.menu", comment: "Text displayed on left side of menu")
    let statisticsText = NSLocalizedString("statistics.menu", comment: "Text displayed on right side of menu")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor(named: "background_screen")
        
        // Create two view controllers to display in the tab bar
        let firstVC = TrackerCollectionViewController(trackerStore: TrackerStore())
        firstVC.tabBarItem = UITabBarItem(title: trackersMenu, image: UIImage(named: "trackersIcon"), tag: 0)
        
        let secondVC = StatisticsViewController(viewModel: StatisticsViewModel())
        secondVC.tabBarItem = UITabBarItem(title: statisticsText, image: UIImage(named: "statisticsIcon"), tag: 1)
        
        // Set the view controllers to display in the tab bar
        viewControllers = [firstVC, secondVC]
    }
}


//В методе viewDidLoad он создает два экземпляра view controller'ов: TrackerCollectionViewController и UIViewController. Оба view controller'а получают белый фон и устанавливаются как элементы вкладок в таббаре, каждый с своим изображением и названием. В расширении TabBarController реализуется делегат NewBehaviorViewControllerDelegate. Метод dismissToTrackerCollectionViewController() закрывает текущий view controller, а затем модально закрывает все view controller'ы, которые были открыты поверх него, чтобы вернуть пользователя на TrackerCollectionViewController.
