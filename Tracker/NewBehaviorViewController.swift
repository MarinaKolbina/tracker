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
        
        let textField = TextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(named: "grey_for_textField")
        view.addSubview(textField)
        
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.backgroundColor = UIColor(named: "grey_for_textField")
        // Регистрируем класс UITableViewCell для ячейки таблицы
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        view.addSubview(tableView)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 73),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
//            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24)
        ])

    }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Получаем ячейку таблицы
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
            
            // Настраиваем текст ячейки
            if indexPath.row == 0 {
                cell.textLabel?.text = "Категория"
            } else {
                cell.textLabel?.text = "Расписание"
            }
            
            return cell
        }

}
    
