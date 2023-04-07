//
//  TabBarController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    var searchText: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.backgroundColor = UIColor(named: "grey_for_searchBar")
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    var date: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    var plusButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plusIcon")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Трекеры"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var littleTitle: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "Что будем отслеживать?"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = .black
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "starIcon"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create items
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 182))
        let leftButton = UIBarButtonItem(customView: searchText)
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navBar.topItem?.titleView = mainTitle
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Add subviews
        view.addSubview(navBar)
        view.addSubview(searchText)
        view.addSubview(date)
        view.addSubview(plusButton)
        view.addSubview(mainTitle)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        
        // Add constraints
        NSLayoutConstraint.activate([
            date.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            date.bottomAnchor.constraint(equalTo: searchText.topAnchor, constant: -11),
            date.widthAnchor.constraint(equalToConstant: 77),
            date.heightAnchor.constraint(equalToConstant: 34),
            
            searchText.widthAnchor.constraint(equalToConstant: 343),
            searchText.heightAnchor.constraint(equalToConstant: 36),
            searchText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            searchText.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -10),
            
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitle.bottomAnchor.constraint(equalTo: searchText.topAnchor, constant: -7),
            
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.bottomAnchor.constraint(equalTo: mainTitle.topAnchor, constant: -13),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            littleTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            littleTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60)
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
