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
    
//    let tableView = UITableView()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Расписание"
        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 55),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            tableView.heightAnchor.constraint(equalToConstant: 525)
////        ])
//
//        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = UIColor(named: "grey_for_days")
//        tableView.layer.cornerRadius = 16
    }
    
}
//
//extension DaysOfTheWeekViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return daysOfWeek.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
//        //        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
//
//        // Настраиваем ячейку
//        cell.configure()
//        cell.textLabel?.text = daysOfWeek[indexPath.row]
//
//        return cell
//    }
//}
//
//extension DaysOfTheWeekViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//}
//
//class MyTableViewCell: UITableViewCell {
//    let dayOfWeek = UILabel()
//    let switchControl = UISwitch()
//
//    func configure() {
//        dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
//        switchControl.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(dayOfWeek)
//        contentView.addSubview(switchControl)
//
//        switchControl.isOn = false
//        accessoryView = switchControl
//        switchControl.onTintColor = UIColor(named: "blue_YP")
//
//        NSLayoutConstraint.activate([
//            dayOfWeek.topAnchor.constraint(equalTo: contentView.topAnchor),
//            dayOfWeek.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            dayOfWeek.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            dayOfWeek.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -10),
//            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//
//    }
//}
