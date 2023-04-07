//
//  MyTableViewCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 06/04/2023.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    let dayOfWeek = UILabel()
    let switchControl = UISwitch()

    func configure() {
        dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(dayOfWeek)
        contentView.addSubview(switchControl)

        switchControl.isOn = false
        switchControl.onTintColor = UIColor(named: "blue_YP")

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
