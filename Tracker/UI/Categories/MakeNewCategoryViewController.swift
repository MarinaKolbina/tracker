//
//   MakeNewCategoryViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 03/07/2023.
//

import UIKit

protocol MakeNewCategoryViewControllerDelegate: AnyObject {
    func didTapReadyButton(label: String)
}

class MakeNewCategoryViewController: UIViewController {
    
    var selectedLabel: String?
    weak var delegate: MakeNewCategoryViewControllerDelegate?
    var text: String = ""
    
    lazy var textField: UITextField = {
        let field = TextField()
        field.placeholder = "Введите название категории"
        field.backgroundColor = UIColor(named: "grey_for_textField")
        field.layer.cornerRadius = 16
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    var isReadyButtonEnabled: Bool = false {
        willSet {
            if newValue {
                readyButton.backgroundColor = UIColorMarshalling.toggleBlackWhiteColor
                readyButton.isEnabled = true
            } else {
                readyButton.backgroundColor = .gray
                readyButton.isEnabled = false
            }
        }
    }
    
    init(title: String) {
        self.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = .white
        title = text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColorMarshalling.toggleBlackWhiteColor]
                
        view.addSubview(textField)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    @objc func didChangedTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        selectedLabel = text
        checkFullForm()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func readyButtonTapped() {
        if let selectedLabel = selectedLabel {
            delegate?.didTapReadyButton(label: selectedLabel)
        } else {
            return
        }
    }
    
    func checkFullForm() {
        if let selectedLabel = selectedLabel {
            isReadyButtonEnabled = selectedLabel != ""
        } else {
            isReadyButtonEnabled = false
        }
    }
}
