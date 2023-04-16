import Foundation
import UIKit
 
protocol DaysOfTheWeekDelegate: AnyObject {
    func didChooseDays(days: [Weekday])
}
 
class DaysOfTheWeekViewController: UIViewController {
    var selectedDays: [Weekday] = []
    weak var delegate: DaysOfTheWeekDelegate?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(WeekdayTableViewCell.self, forCellReuseIdentifier: "WeekdayTableViewCell")
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
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
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
        let cells = tableView.visibleCells as! Array<WeekdayTableViewCell>
        var weekDays = Set(selectedDays)
        for cell in cells {
            if cell.switchControl.isOn {
                weekDays.insert(cell.weekDay)
            }
        }
        
        delegate?.didChooseDays(days: weekDays.sorted(by: <))
        dismiss(animated: true)
    }
}
 
extension DaysOfTheWeekViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayTableViewCell", for: indexPath) as! WeekdayTableViewCell
        let weekDay = Weekday.allCases[indexPath.row]
        cell.configure(switchIsOn: selectedDays.contains(weekDay), day: weekDay)
        return cell
    }
}
 
extension DaysOfTheWeekViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//Сначала реализация протокола DaysOfTheWeekDelegate, который определяет метод didChooseDays, принимающий массив days типа [Weekday].

//Далее определен класс DaysOfTheWeekViewController. В этом классе определены проперти selectedDays и delegate, а также элементы пользовательского интерфейса, такие как tableView и readyButton.

//В методе viewDidLoad инициализируются и настраиваются элементы пользовательского интерфейса, устанавливаются их ограничения и устанавливаются объекты dataSource и delegate для tableView.

//Метод didTapReadyButton вызывается при нажатии на кнопку readyButton. В этом методе извлекаются все видимые ячейки tableView и обновляется массив weekDays с помощью switchControl каждой ячейки. Затем метод didChooseDays вызывается у делегата, передавая отсортированный массив weekDays, и вызывается метод dismiss для закрытия DaysOfTheWeekViewController.

//Два расширения также определены: UITableViewDataSource и UITableViewDelegate, которые обеспечивают функциональность таблицы в DaysOfTheWeekViewController.
