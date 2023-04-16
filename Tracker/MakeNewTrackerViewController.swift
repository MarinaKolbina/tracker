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
        presentBehaviorController(eventType: "Behavior")
    }
    
    @objc func didTapIrregularEventButton() {
        presentBehaviorController(eventType: "IrregularEvent")
    }
    
    func presentBehaviorController(eventType: String) {
        let newBehaviorViewController = NewBehaviorViewController()
        newBehaviorViewController.eventType = eventType
        newBehaviorViewController.delegate = presentingViewController as? TabBarController
        let navigationController = UINavigationController(rootViewController: newBehaviorViewController)
        newBehaviorViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

//Внутри класса создаются две кнопки behaviorButton и irregularEventButton, на которые назначаются обработчики нажатия. Также в классе реализуется метод presentBehaviorController, который создает экземпляр NewBehaviorViewController и устанавливает его свойство eventType равным переданному аргументу, после чего назначает делегатом контроллера presentingViewController и отображает его с помощью present(_:animated:completion:).

//Метод presentBehaviorController вызывается в обработчиках нажатия кнопок behaviorButton и irregularEventButton и передает соответствующий тип события в качестве аргумента. Кроме того, класс MakeNewTrackerViewController является экраном создания нового трекера, на котором отображаются эти кнопки. В методе viewDidLoad() происходит установка фона экрана в белый цвет и добавление кнопок на экран с помощью метода addSubview(). Далее задаются констрейнты для кнопок, чтобы они были расположены по центру экрана и с некоторым расстоянием между собой.
