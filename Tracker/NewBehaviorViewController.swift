//
//  NewBehaviorViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation
import UIKit

class NewBehaviorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 75
        table.backgroundColor = UIColor(named: "grey_for_textField")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return table
    }()
    
    let textField: UITextField = {
        let field = TextField()
        field.placeholder = "Введите название трекера"
        field.backgroundColor = UIColor(named: "grey_for_textField")
        field.layer.cornerRadius = 16
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Новая привычка"
        
        //Добавим скроллвью
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //Добавим стеквью
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Иерархия вью
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(textField)
        stackView.addArrangedSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
       
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
       
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
       
            tableView.topAnchor.constraint(equalTo:textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo:textField.bottomAnchor, constant: 174)
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
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // Настраиваем текст ячейки
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
        } else {
            cell.textLabel?.text = "Расписание"
            cell.accessoryType = .disclosureIndicator // добавляем пользовательский индикатор доступности
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let daysOfTheWeekViewController = DaysOfTheWeekViewController()
            navigationController?.pushViewController(daysOfTheWeekViewController, animated: true) //или тут лучше презент?
        }
    }
    
}

