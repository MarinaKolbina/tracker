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
            categoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
