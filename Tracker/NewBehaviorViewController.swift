//
//  NewBehaviorViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation
import UIKit

class NewBehaviorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Новая привычка"
        
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(named: "grey_for_textField")
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 73),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])

    }
    
}
