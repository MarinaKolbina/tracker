//
//  WeekdayTableViewCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 06/04/2023.
//

import Foundation
import UIKit

class WeekdayTableViewCell: UITableViewCell {
   let dayOfWeek = UILabel()
   let switchControl = UISwitch()
   var weekDay = Weekday.monday
   
   func configure(switchIsOn: Bool, day: Weekday) {
       textLabel?.text = day.day.fullForm
       weekDay = day

       switchControl.isOn = switchIsOn
       switchControl.onTintColor = UIColor(named: "blue_YP")
       
       backgroundColor = .clear
       selectionStyle = .none
       
       contentView.addSubview(dayOfWeek)
       contentView.addSubview(switchControl)
       
       
       dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
       switchControl.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
           dayOfWeek.topAnchor.constraint(equalTo: contentView.topAnchor),
           dayOfWeek.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           dayOfWeek.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           dayOfWeek.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           
           switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
       ])
   }
}

// Класс WeekdayTableViewCell наследует от UITableViewCell и содержит два проперти: dayOfWeek и switchControl. С помощью метода configure(switchIsOn: Bool, day: Weekday) устанавливается содержимое ячейки и ее расположение. Метод configure принимает два параметра: switchIsOn - логическое значение, указывающее, должен ли переключатель быть включен или выключен, и day - значение перечисления типа Weekday, представляющее день недели. Внутри метода устанавливается содержимое и расположение ячейки. Например, устанавливается текст day.day.fullForm в textLabel, устанавливается значение переключателя switchControl.isOn равным switchIsOn и цвет на UIColor(named: "blue_YP"). Кроме того, добавляются сабвью dayOfWeek и switchControl в contentView, и устанавливаются их констрейнты.
