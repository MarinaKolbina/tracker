//
//  NewTrackerCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 04/04/2023.
//

import Foundation
import UIKit
 
class TrackerCollectionViewCell: UICollectionViewCell {
    
    let trackerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "green_for_tracker")
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tinyView: UIView = {
        let tinyView = UIView()
        tinyView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        tinyView.layer.cornerRadius = 11
        tinyView.translatesAutoresizingMaskIntoConstraints = false
        return tinyView
    }()
    
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😀"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Поливать растения"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let daysCounter: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roundButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17
        button.backgroundColor = UIColor(named: "green_for_tracker")
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        emojiLabel.frame = trackerBackgroundView.bounds
        
        trackerBackgroundView.addSubview(tinyView)
        trackerBackgroundView.addSubview(emojiLabel)
        trackerBackgroundView.addSubview(titleLabel)
        
        bottomStackView.addArrangedSubview(daysCounter)
        bottomStackView.addArrangedSubview(roundButton)
        
        mainStackView.addArrangedSubview(trackerBackgroundView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            
            tinyView.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor),
            tinyView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            tinyView.heightAnchor.constraint(equalToConstant: 24),
            tinyView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: trackerBackgroundView.topAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: -12),
            
            daysCounter.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 12),
            
            roundButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -12),
            roundButton.widthAnchor.constraint(equalToConstant: 34),
            roundButton.heightAnchor.constraint(equalToConstant: 34),
            
            mainStackView.heightAnchor.constraint(equalToConstant: 132),
            mainStackView.widthAnchor.constraint(equalToConstant: 167),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        roundButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        roundButton.layer.opacity = 0.3
        print("Button tapped!")
    }
}
