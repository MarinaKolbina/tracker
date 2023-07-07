//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 25/06/2023.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell {
    var categoryName = UILabel()
  
    func configure(category: TrackerCategory) {
        self.categoryName.text = category.label
        backgroundColor = .clear
        selectionStyle = .none
       
        contentView.addSubview(categoryName)
       categoryName.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
        categoryName.topAnchor.constraint(equalTo: contentView.topAnchor),
        categoryName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        categoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        categoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

       ])
   }
}

//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    // Снимаем выделение с предыдущей выбранной ячейки
//    if let selectedIndexPath = tableView.indexPathForSelectedRow {
//        tableView.deselectRow(at: selectedIndexPath, animated: true)
//    }
//
//    // Получаем выбранную ячейку
//    let cell = tableView.cellForRow(at: indexPath)
//
//    // Устанавливаем галочку в качестве аксессуара ячейки
//    cell?.accessoryType = .checkmark
//}
