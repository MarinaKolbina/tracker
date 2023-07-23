//
//  NewTrackerCell.swift
//  Tracker
//
//  Created by Marina Kolbina on 04/04/2023.
//

import Foundation
import UIKit
 
protocol TrackerCellDelegate: AnyObject {
    func didTapRoundButton(of cell: TrackerCollectionViewCell, with tracker: Tracker)
}
 
class TrackerCollectionViewCell: UICollectionViewCell {
    
    let trackerBackgroundView: UIView = {
        let view = UIView()
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
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
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
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var roundButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17
        button.backgroundColor = UIColor(named: "green_for_tracker")
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(didTapRoundButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let daysText = NSLocalizedString("days", comment: "Text to count days")
    let dayText = NSLocalizedString("day", comment: "Text to count day")

    static let identifier = "trackerCell"
    private var days = 0 {
        didSet {
            let daysString = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of days"), days)
            daysCounter.text = "\(daysString)"
        }
    }
    
    private var tracker: Tracker?
    weak var delegate: TrackerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
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
            titleLabel.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -12),
            
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
    
    func configure(tracker: Tracker, days: Int, isDone: Bool) {
        self.tracker = tracker
        self.days = days
        
        titleLabel.text = tracker.label
        emojiLabel.text = tracker.emoji
        trackerBackgroundView.backgroundColor = tracker.color
        roundButton.backgroundColor = tracker.color
        setupRoundButtonView(isDone)
    }
    
    func setupRoundButtonView(_ isDone: Bool) {
        if isDone {
            roundButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            roundButton.layer.opacity = 0.3
        } else {
            roundButton.setImage(UIImage(systemName: "plus"), for: .normal)
            roundButton.layer.opacity = 1
        }
    }
    
    func changeRoundButtonState(isDone: Bool) {
        days = isDone ? days + 1 : days - 1
        setupRoundButtonView(isDone)
    }
    
    @objc
    private func didTapRoundButton() {
        print("Button tapped!")
        guard let tracker else { return }
        delegate?.didTapRoundButton(of: self, with: tracker)
    }
}
