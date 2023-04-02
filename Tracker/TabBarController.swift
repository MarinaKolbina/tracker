//
//  TabBarController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create items
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 182))
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        let searchTextField = UISearchTextField()
        searchTextField.backgroundColor = UIColor(named: "grey_for_searchBar")
        searchTextField.placeholder = "Поиск"
        let leftButton = UIBarButtonItem(customView: searchTextField)
        navBar.topItem?.setLeftBarButton(leftButton, animated: false)
        view.addSubview(searchTextField)

        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
//        let rightButton = UIBarButtonItem(customView: datePicker)
//        navBar.topItem?.setRightBarButton(rightButton, animated: false)
        view.addSubview(datePicker)
        
        let button = UIButton()
        let image = UIImage()
        button.setImage(UIImage(named: "plusIcon"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        navBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: button)
        view.addSubview(button)
        
        let title = UILabel()
        title.text = "Трекеры"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = .black
        navBar.topItem?.titleView = title
        view.addSubview(title)
        
        let imageView = UIImageView(image: UIImage(named: "starIcon"))
        view.addSubview(imageView)
        
        let titleImage = UILabel()
        titleImage.text = "Что будем отслеживать?"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = .black
        view.addSubview(titleImage)

        // Add constraints
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
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 19),
            button.heightAnchor.constraint(equalToConstant: 18),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -13)
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
    
}

