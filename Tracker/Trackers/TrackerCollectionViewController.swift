//
//  TrackerCollectionViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 07/04/2023.
//
 
import Foundation
import UIKit
 
class TrackerCollectionViewController: UIViewController, UICollectionViewDelegate {
    var plusButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plusIcon")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Трекеры"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.backgroundColor = .white
        date.tintColor = .blue
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.calendar = Calendar(identifier: .iso8601)
        date.translatesAutoresizingMaskIntoConstraints = false
        date.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        return date
    }()
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Поиск"
        view.searchBarStyle = .minimal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "starIcon"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var littleTitle: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "Что будем отслеживать?"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = .black
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    lazy var trackersCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.allowsMultipleSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collection.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(label: "Важное", trackers: [Tracker(label: "First_init", emoji: "🙂", color: .orange, schedule: [Weekday.monday]),
                                                    Tracker(label: "Second_init", emoji: "😻", color: .systemPink, schedule: [Weekday.sunday]),
                                                    Tracker(label: "Third_init", emoji: "🐶", color: .systemIndigo, schedule: [Weekday.saturday]),
                                                    Tracker(label: "Fourth_init", emoji: "❤️", color: .green, schedule: [Weekday.saturday]),
                                                    Tracker(label: "Fifth_init", emoji: "🏝", color: .systemBlue, schedule: [Weekday.saturday]),
                                                    Tracker(label: "First_init", emoji: "🍔", color: .systemPurple, schedule: [Weekday.saturday])]),
        TrackerCategory(label: "Не важное", trackers: [Tracker(label: "First_init_2", emoji: "🙂", color: .orange, schedule: [Weekday.monday]),
                                                       Tracker(label: "Second_init_2", emoji: "😻", color: .systemPink, schedule: [Weekday.tuesday]),
                                                       Tracker(label: "Third_init_2", emoji: "🐶", color: .systemIndigo, schedule: [Weekday.saturday]),
                                                       Tracker(label: "Fourth_init_2", emoji: "❤️", color: .green, schedule: [Weekday.saturday]),
                                                       Tracker(label: "Fifth_init_2", emoji: "🏝", color: .systemBlue, schedule: [Weekday.saturday]),
                                                       Tracker(label: "First_init_2", emoji: "🍔", color: .systemPurple, schedule: [Weekday.saturday])])]
    
    private var visibleCategories: [TrackerCategory] = [] {
        didSet {
            guard let previosDayNumber = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return }
            let weekday = Calendar.current.component(.weekday, from: previosDayNumber)
            
            var currentVisibleCategories: [TrackerCategory] = []
            for category in categories {
                var currentTrackers: [Tracker] = []
                for tracker in category.trackers {
                    guard let schedule = tracker.schedule else { return }
                    if schedule.filter({ $0.day.index == weekday }).count > 0 && tracker.label.hasPrefix(searchBarText){
                        currentTrackers.append(tracker)
                    }
                }
                
                if currentTrackers.count != 0 {
                    currentVisibleCategories.append(TrackerCategory(label: category.label, trackers: currentTrackers))
                }
            }
            
            let categoriesAmount = currentVisibleCategories.count
            imageView.isHidden = categoriesAmount > 0
            littleTitle.isHidden = categoriesAmount > 0
            trackersCollectionView.isHidden = categoriesAmount == 0
 
            visibleCategories = currentVisibleCategories
        }
    }
    private var searchBarText: String = "" {
        didSet {
            visibleCategories = categories
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
    
    override func viewDidLoad() {
        //Create items
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 182)
        let leftButton = UIBarButtonItem(customView: searchBar)
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationBar.topItem?.titleView = mainTitle
        
        visibleCategories = categories
        
        //Add subviews
        view.addSubview(plusButton)
        view.addSubview(mainTitle)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        view.addSubview(navigationBar)
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.bottomAnchor.constraint(equalTo: mainTitle.topAnchor, constant: -13),
            
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitle.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -7),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -11),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchBar.widthAnchor.constraint(equalToConstant: 343),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -10),
            
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            littleTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            littleTitle.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 60),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    //Methods
    
    @objc func didTapPlusButton() {
        let makeNewTrackerViewController = MakeNewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: makeNewTrackerViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func didChangeDatePicker(_ sender: UIDatePicker) {
        currentDate = sender.date
        visibleCategories = categories
        trackersCollectionView.reloadData()
    }
}
 
// MARK: - UICollectionViewDataSource
 
extension TrackerCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isDone = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        
        cell.configure(tracker: tracker, days: daysCount, isDone: isDone)
        cell.delegate = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = visibleCategories[indexPath.section].label
        view.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 19.0)
        return view
    }
}
 
// MARK: - UICollectionViewDelegateFlowLayout
 
extension TrackerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
}
 
// MARK: - UISearchBarDelegate
 
extension TrackerCollectionViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        trackersCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBarText = ""
        trackersCollectionView.reloadData()
    }
}
 
// MARK: - NewBehaviorViewControllerDelegate
extension TrackerCollectionViewController: NewBehaviorViewControllerDelegate {
    func didTapCreateButton(_ tracker: Tracker, section: String) {
        var newCategories = categories.filter({ $0.label != section })
        var newTrackers: [Tracker]
        if var changingCategoryTrackers = categories.filter({ $0.label == section }).first?.trackers {
            changingCategoryTrackers.append(tracker)
            newTrackers = changingCategoryTrackers
        } else {
            newTrackers = [tracker]
        }
        newCategories.append(TrackerCategory(label: section, trackers: newTrackers))
        categories = newCategories
        visibleCategories = categories
        trackersCollectionView.reloadData()
    }
}
 
// MARK: - TrackerCellDelegate
extension TrackerCollectionViewController: TrackerCellDelegate {
    func didTapRoundButton(of cell: TrackerCollectionViewCell, with tracker: Tracker) {
        if currentDate > Date() { return }
        
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.changeRoundButtonState(isDone: false)
        } else {
            completedTrackers.insert(trackerRecord)
            cell.changeRoundButtonState(isDone: true)
        }
    }
}
 
//В классе определены следующие свойства:

//plusButton - кнопка, инициализированная как UIButton с изображением и методом-обработчиком нажатия;
//mainTitle - заголовок, инициализированный как UILabel с текстом, шрифтом и цветом;
//datePicker - виджет выбора даты, инициализированный как UIDatePicker с определенными свойствами;
//searchBar - строка поиска, инициализированная как UISearchBar с текстом-подсказкой и стилем;
//imageView - изображение, инициализированное как UIImageView с изображением;
//littleTitle - подзаголовок, инициализированный как UILabel с текстом, шрифтом и цветом;
//navigationBar - строка навигации, инициализированная как UINavigationBar.
//Также в классе определены массивы trackers и emojis, содержащие определенные строки и эмодзи.
//
//В методе viewDidLoad() вызываются методы setUp(), applyLayOut() и checkAvailableTrackers(), а также задаются определенные свойства коллекции trackersCollectionView.
//
//Класс также содержит ряд методов, в том числе didTapPlusButton(), checkAvailableTrackers(), setUp() и applyLayOut().
//
//Дополнительно класс расширяется методами протоколов UISearchBarDelegate, UICollectionViewDataSource и UICollectionViewDelegateFlowLayout.
