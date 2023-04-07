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
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        table.backgroundColor = UIColor(named: "grey_for_days")
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var readyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Расписание"
        
        view.addSubview(tableView)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @objc func didTapReadyButton() {
        let NewBehaviorViewController = NewBehaviorViewController()
        //что-то другое тут должно быть
        //        let navigationController = UINavigationController(rootViewController: NewBehaviorViewController)
        //        NewBehaviorViewController.modalPresentationStyle = .overFullScreen
        //        present(navigationController, animated: true, completion: nil)
    }
    
}

extension DaysOfTheWeekViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        
        cell.configure()
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        
        return cell
    }
}

extension DaysOfTheWeekViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
