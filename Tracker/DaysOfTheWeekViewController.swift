//
//  DaysOfTheWeekViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 03/04/2023.
//

import Foundation
import UIKit

class DaysOfTheWeekViewController: UIViewController {
    
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Расписание"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension DaysOfTheWeekViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        //        cell.configure()
        //        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        
        // Настраиваем ячейку
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        let switchControl = UISwitch()
        switchControl.isOn = true
        cell.accessoryView = switchControl
        
        return cell
    }
}

extension DaysOfTheWeekViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

class MyTableViewCell: UITableViewCell {
    let dayOfWeek = UILabel()
    let switchControl = UISwitch()
    
    func configure() {
        dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayOfWeek)
        contentView.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            dayOfWeek.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayOfWeek.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dayOfWeek.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayOfWeek.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -10),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
//        textField.placeholder = "Enter text here"
    }
}
