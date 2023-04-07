//
//  MakeNewTrackerViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

class MakeNewTrackerViewController: UIViewController {
    
    var behaviorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(didTapBehaviorButton), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var irregularEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Создание трекера"

        //Create items
        view.addSubview(behaviorButton)
        view.addSubview(irregularEventButton)

        NSLayoutConstraint.activate([
            behaviorButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            behaviorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            behaviorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            behaviorButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.topAnchor.constraint(equalTo: behaviorButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func didTapBehaviorButton() {
        let NewBehaviorViewController = NewBehaviorViewController()
        let navigationController = UINavigationController(rootViewController: NewBehaviorViewController)
//        navigationController?.pushViewController(makeNewTrackerViewController, animated: true)
        NewBehaviorViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func didTapIrregularEventButton() {
        let NewIrregularEventViewController = NewIrregularEventViewController()
        let navigationController = UINavigationController(rootViewController: NewIrregularEventViewController)
//        navigationController?.pushViewController(makeNewTrackerViewController, animated: true)
        NewIrregularEventViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
