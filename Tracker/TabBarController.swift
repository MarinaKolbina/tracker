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
 
// MARK: - NewBehaviorViewControllerDelegate
 
extension TabBarController: NewBehaviorViewControllerDelegate {
    func dismissToTrackerCollectionViewController() {
        dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//В методе viewDidLoad он создает два экземпляра view controller'ов: TrackerCollectionViewController и UIViewController. Оба view controller'а получают белый фон и устанавливаются как элементы вкладок в таббаре, каждый с своим изображением и названием. В расширении TabBarController реализуется делегат NewBehaviorViewControllerDelegate. Метод dismissToTrackerCollectionViewController() закрывает текущий view controller, а затем модально закрывает все view controller'ы, которые были открыты поверх него, чтобы вернуть пользователя на TrackerCollectionViewController.
