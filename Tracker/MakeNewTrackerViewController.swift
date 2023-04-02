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
        title = "Создание трекера"

        //Create items
        let behaviorButton = UIButton()
        behaviorButton.backgroundColor = .black
        behaviorButton.setTitleColor(.white, for: .normal)
        behaviorButton.setTitle("Привычка", for: .normal)
        behaviorButton.addTarget(self, action: #selector(didTapBehaviorButton), for: .touchUpInside)
        view.addSubview(behaviorButton)

        let irregularEventButton = UIButton()
        irregularEventButton.backgroundColor = .black
        irregularEventButton.setTitleColor(.white, for: .normal)
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        view.addSubview(irregularEventButton)

        behaviorButton.translatesAutoresizingMaskIntoConstraints = false
        behaviorButton.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            behaviorButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            behaviorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            behaviorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            behaviorButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
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
