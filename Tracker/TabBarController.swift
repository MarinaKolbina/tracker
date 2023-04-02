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
        
        //Create items
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 182))
        
        let searchTextField = UISearchTextField()
        searchTextField.backgroundColor = UIColor(named: "grey_for_searchBar")
        searchTextField.placeholder = "Поиск"
        let leftButton = UIBarButtonItem(customView: searchTextField)
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)

        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
//        let rightButton = UIBarButtonItem(customView: datePicker)
//        navBar.topItem?.setRightBarButton(rightButton, animated: false)
        
        let plusButton = UIButton.systemButton(
            with: UIImage(named: "plusIcon")!,
            target: self,
            action: #selector(didTapPlusButton)
            )
        navBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        let title = UILabel()
        title.text = "Трекеры"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = .black
        navBar.topItem?.titleView = title
        
        let imageView = UIImageView(image: UIImage(named: "starIcon"))
        
        let titleImage = UILabel()
        titleImage.text = "Что будем отслеживать?"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = .black

        
        //Add subviews
        view.addSubview(navBar)
        view.addSubview(searchTextField)
        view.addSubview(datePicker)
        view.addSubview(plusButton)
        view.addSubview(title)
        view.addSubview(imageView)
        view.addSubview(titleImage)
        
        // Add constraints
        navBar.translatesAutoresizingMaskIntoConstraints = false

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -11),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalToConstant: 343),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            searchTextField.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10)
        ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -7)
        ])
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -13)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60)
        ])
        
        // Create two view controllers to display in the tab bar
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .white
        firstVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackersIcon"), tag: 0)
        
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .white
        secondVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticsIcon"), tag: 1)
 
        
        // Set the view controllers to display in the tab bar
        viewControllers = [firstVC, secondVC]
    }
    
    
    //Methods
    
    @objc func didTapPlusButton() {
        let makeNewTrackerViewController = MakeNewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: makeNewTrackerViewController)
//        navigationController?.pushViewController(makeNewTrackerViewController, animated: true)
        makeNewTrackerViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    


    
}

