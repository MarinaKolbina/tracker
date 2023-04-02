//
//  MakeNewTrackerViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

class MakeNewTrackerViewController: UIViewController {
    
    override func viewDidLoad() {
         super.viewDidLoad()
        

        view.backgroundColor = .white
        
        //Create items
        let behaviorButton = UIButton()
        behaviorButton.tintColor = .black
        view.addSubview(behaviorButton)

        let irregularEventButton = UIButton()
        irregularEventButton.tintColor = .black
        view.addSubview(irregularEventButton)

        let title = UILabel()
        title.text = "Создание трекера"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        title.textColor = .black
        view.addSubview(title)

        behaviorButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            behaviorButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 335),
            behaviorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            behaviorButton.widthAnchor.constraint(equalToConstant: 335),
            behaviorButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            irregularEventButton.topAnchor.constraint(equalTo: behaviorButton.bottomAnchor, constant: -16),
            irregularEventButton.centerYAnchor.constraint(equalTo: behaviorButton.centerYAnchor),
            irregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: behaviorButton.bottomAnchor, constant: -16),
            title.centerYAnchor.constraint(equalTo: behaviorButton.centerYAnchor),
            title.widthAnchor.constraint(equalToConstant: 335),
            title.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
