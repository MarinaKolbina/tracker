//
//  StatisticCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/07/2023.
//

import UIKit

class StatisticCell: UITableViewCell {
    
    static let identifier = "statisticCell"
    let uiColorMarshalling = UIColorMarshalling()

    private let gradientBorderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background_screen")
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.distribution = .fill
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColorMarshalling.toggleBlackWhiteColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColorMarshalling.toggleBlackWhiteColor
        return label
    }()
    
    private var gradientBorder: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBorderView.bounds
        gradientLayer.colors = [
            uiColorMarshalling.colorForGradient(from: "#FD4C49").cgColor,
            uiColorMarshalling.colorForGradient(from: "#46E69D").cgColor,
            uiColorMarshalling.colorForGradient(from: "#007BFA").cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBorder.removeFromSuperlayer()

        DispatchQueue.main.async { [weak self] in
            self?.gradientBorderView.layer.insertSublayer(self?.gradientBorder ?? CAGradientLayer(), at: 0)
        }
    }
    
    func configureCell(with model: StatisticsCellModel) {
        contentView.backgroundColor = UIColor(named: "background_screen")
                        
        setElements()
        setupConstraints()
        
        valueLabel.text = model.value
        descriptionLabel.text = model.description
    }
    
    private func setElements() {
        contentView.addSubview(gradientBorderView)
        gradientBorderView.addSubview(mainView)
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBorderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            mainView.leadingAnchor.constraint(equalTo: gradientBorderView.leadingAnchor, constant: 1),
            mainView.topAnchor.constraint(equalTo: gradientBorderView.topAnchor, constant: 1),
            mainView.trailingAnchor.constraint(equalTo: gradientBorderView.trailingAnchor, constant: -1),
            mainView.bottomAnchor.constraint(equalTo: gradientBorderView.bottomAnchor, constant: -1),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 11),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -11),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -11)
        ])
    }
}
