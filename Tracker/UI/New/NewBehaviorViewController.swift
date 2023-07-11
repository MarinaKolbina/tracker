import Foundation
import UIKit
 
protocol NewBehaviorViewControllerDismissDelegate: AnyObject {
    func dismissToTrackerCollectionViewController()
}
 
protocol NewBehaviorViewControllerDelegate: AnyObject {
    func didTapCreateButton(_ tracker: Tracker, category: TrackerCategory)
}
 
class NewBehaviorViewController: UIViewController, CategoriesViewDelegate {
    
    lazy var textField: UITextField = {
        let field = TextField()
        field.placeholder = "Введите название трекера"
        field.backgroundColor = UIColor(named: "grey_for_textField")
        field.layer.cornerRadius = 16
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    var validationLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 75
        table.backgroundColor = UIColor(named: "grey_for_textField")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return table
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var categoriesViewController = CategoriesViewController(viewModel: CategoriesViewModel(trackerCategoryStore: trackerCategoryStore))
    
    var eventType: String?
    
    let emojis = Constants().emojis
    let colors = Constants().colors
    
    var selectedLabel: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var selectedDays: [Weekday] = []
    var selectedCategory: TrackerCategory?
    
    var isValidationLabelVisible = false {
        didSet {
            if isValidationLabelVisible {
                stackView.insertArrangedSubview(validationLabel, at: 1)
            } else {
                validationLabel.removeFromSuperview()
            }
        }
    }
    
    var isCreateButtonEnabled: Bool = false {
        willSet {
            if newValue {
                createButton.backgroundColor = .black
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = .gray
                createButton.isEnabled = false
            }
        }
    }
    
    weak var delegate: NewBehaviorViewControllerDelegate?
    weak var delegateDismiss: NewBehaviorViewControllerDismissDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = .white
        guard let eventType = eventType else { return }
        if eventType == "Behavior" {
            title = "Новая привычка"
        } else if eventType == "IrregularEvent" {
            title = "Новое нерегулярное событие"
            selectedDays = Weekday.allCases
            
        }
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(emojiCollectionView)
        stackView.addArrangedSubview(colorsLabel)
        stackView.addArrangedSubview(colorsCollectionView)
        stackView.addArrangedSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            emojiLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 9),

            emojiCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            colorsLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12),
            
            colorsCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        
        if eventType == "Behavior" {
            NSLayoutConstraint.activate([tableView.heightAnchor.constraint(equalToConstant: 150)])
        } else if eventType == "IrregularEvent" {
            NSLayoutConstraint.activate([tableView.heightAnchor.constraint(equalToConstant: 75)])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoriesViewController.provideSelectedCategory = { [weak self] category in
            self?.selectedCategory = category
            self?.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let daysOfTheWeekViewController = DaysOfTheWeekViewController()
            daysOfTheWeekViewController.delegate = self
            daysOfTheWeekViewController.selectedDays = selectedDays
            let navigationController = UINavigationController(rootViewController: daysOfTheWeekViewController)
            daysOfTheWeekViewController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
        
        if indexPath.row == 0 {
            categoriesViewController.delegate = self
//            categoriesViewController.selectedCategories = selectedCategories
            let navigationController = UINavigationController(rootViewController: categoriesViewController)
            categoriesViewController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func didChangedTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        selectedLabel = text
        isValidationLabelVisible = text.count > 38
        checkFullForm()
    }
    
    @objc func cancelButtonTapped() {
        delegateDismiss?.dismissToTrackerCollectionViewController()
    }
    
    @objc func createButtonTapped() {
        if let selectedLabel = selectedLabel, let selectedEmoji = selectedEmoji, let selectedColor = selectedColor {
            let tracker = Tracker(label: selectedLabel,
                                  emoji: selectedEmoji,
                                  color: selectedColor,
                                  schedule: selectedDays
            )
            print(tracker)
            delegate?.didTapCreateButton(tracker, category: selectedCategory!)
            delegateDismiss?.dismissToTrackerCollectionViewController()
        } else {
            return
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func checkFullForm() {
        if let _ = selectedEmoji,
           let _ = selectedColor,
           let selectedLabel = selectedLabel {
            isCreateButtonEnabled = selectedLabel != "" && !isValidationLabelVisible && selectedDays != []
        } else {
            isCreateButtonEnabled = false
        }
    }
}
 
 
// MARK: - UITableViewDataSource, UITableViewDelegate
 
extension NewBehaviorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventType == "Behavior" {
            return 2
        } else if eventType == "IrregularEvent" {
            return 1
        } else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку таблицы
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .gray
        
        // Настраиваем текст ячейки
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            // Будет доделано в следующих спринтах
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = selectedCategory?.label
        } else {
            cell.textLabel?.text = "Расписание"
            cell.accessoryType = .disclosureIndicator // добавляем пользовательский индикатор доступности
            if selectedDays.count < 7 {
                cell.detailTextLabel?.text = selectedDays.map{ $0.day.shortForm }.joined(separator: ", ")
            } else {
                cell.detailTextLabel?.text = "Каждый день"
            }
        }
        return cell
    }
}
 
// MARK: - UICollectionViewDataSource
 
extension NewBehaviorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else if collectionView == colorsCollectionView {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: UICollectionViewCell
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            cell.configure(emoji: emojis[indexPath.row])
            return cell
        } else if collectionView == colorsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            cell.configure(color: colors[indexPath.row]!)
            return cell
//            cell.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        } else {
            return UICollectionViewCell()
        }
    }
}
 
// MARK: - UICollectionViewDelegateFlowLayout
 
extension NewBehaviorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select")
        if collectionView == emojiCollectionView {
            print("emoji select")
            if let cell = collectionView.cellForItem(at: indexPath) {
                selectedEmoji = emojis[indexPath.row]
                cell.contentView.backgroundColor = UIColor(named: "grey_for_emojies")
            }
        } else if collectionView == colorsCollectionView {
            print("color select")
            if let cell = collectionView.cellForItem(at: indexPath) {
                selectedColor = colors[indexPath.row]
                cell.contentView.layer.borderWidth = 3
            }
        }
        checkFullForm()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = .clear
            }
        } else if collectionView == colorsCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.layer.borderWidth = 0
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let availableSpace = collectionView.frame.width - (19 + 19 + 6 * 52)
        let cellWidth = availableSpace / 5
        
        return cellWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
 
extension NewBehaviorViewController: DaysOfTheWeekDelegate {
    func didChooseDays(days: [Weekday]) {
        // сохраняем выбранные дни в свойство
        selectedDays = days
        // обновляем ячейку "Расписание"
        tableView.reloadData()
        checkFullForm()
    }
}

//Данный код на Swift представляет собой реализацию пользовательского интерфейса для создания нового поведения в приложении. Он содержит различные элементы пользовательского интерфейса, такие как текстовое поле, таблицу, коллекции и кнопки.

//Этот код также содержит протокол NewBehaviorViewControllerDelegate, который определяет метод dismissToTrackerCollectionViewController(), предназначенный для связи между NewBehaviorViewController и другим контроллером.
//
//NewBehaviorViewController также содержит ленивые свойства, которые инициализируют элементы пользовательского интерфейса, такие как textField, tableView, emojiCollectionView и colorsCollectionView. Кроме того, он также содержит массивы emojis и colors, которые определяют список доступных значков и цветов.
//
//Этот код также реализует методы делегата UITableViewDataSource и UITableViewDelegate для управления таблицей, а также методы делегата UICollectionViewDataSource и UICollectionViewDelegate для управления коллекциями.
////
////Наконец, этот код содержит две функции для обработки нажатий на кнопки "Отменить" и "Создать". В методе viewDidLoad() устанавливаются ограничения для различных элементов интерфейса, таких как scrollView, stackView, textField, emojiLabel, emojiCollectionView, colorsLabel, colorsCollectionView и buttonsStackView. Затем, если eventType равен "Behavior", высота tableView устанавливается на 150, а если eventType равен "IrregularEvent", то высота tableView устанавливается на 75.
//
//Метод tableView(_:didSelectRowAt:) вызывается при выборе пользователем строки в таблице и открывает экран DaysOfTheWeekViewController. Метод cancelButtonTapped() вызывается при нажатии на кнопку "Отмена" и закрывает экран. Метод createButtonTapped() вызывается при нажатии на кнопку "Создать" и создает новый трекер типа Tracker с данными, введенными пользователем в textField, emojiCollectionView и colorsCollectionView, а также выбранным расписанием selectedDays.
//
//Расширение NewBehaviorViewController содержит реализацию методов UITableViewDataSource и UITableViewDelegate для отображения данных в таблице и UICollectionViewDataSource и UICollectionViewDelegateFlowLayout для отображения данных в коллекции.
