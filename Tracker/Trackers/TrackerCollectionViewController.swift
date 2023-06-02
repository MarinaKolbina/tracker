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

    private var searchBarText: String = "" {
        didSet {
            try? trackerStore.fetchFilteredTrackers(date: currentDate, searchString: searchBarText)
            reloadTrackersCollectionView()
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    
    override func viewDidLoad() {
        let category1 = TrackerCategory(id: UUID(uuidString: "254D234B-9D26-42A1-96B4-3A4C70C3399D")!, label: "Важное")
        let category2 = TrackerCategory(id: UUID(uuidString: "FB87FB52-835A-408A-A72C-6E143CD7369B")!, label: "Неважное")
        
        let tracker1 = Tracker(id: UUID(uuidString: "32955682-0166-4AE7-A872-0FBC21EB9832")!, label: "test", emoji: "🙂", color: UIColor.systemPink, schedule: [Weekday.thurshday, Weekday.tuesday])
        let tracker2 = Tracker(id: UUID(uuidString: "B210C14B-E918-4BA4-A828-74BB6E10897B")!, label: "test2", emoji: "🐶", color: UIColor.systemGreen, schedule: [Weekday.thurshday, Weekday.sunday])
        
        if trackerCategoryStore.trackersCategories.count == 0 {
            do {
                try trackerCategoryStore.addNewCategory(category1)
                try trackerCategoryStore.addNewCategory(category2)
            } catch {
                print("Creating tracker \(error)")
            }
        }
        
        if trackerStore.trackers.count == 0 {
            do {
                try trackerStore.addNewTracker(tracker1, with: category1)
                try trackerStore.addNewTracker(tracker2, with: category1)
            } catch {
                print("Creating tracker \(error)")
            }
        }
        
        print(trackerStore.trackers)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        //Create items
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 182)
        let leftButton = UIBarButtonItem(customView: searchBar)
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationBar.topItem?.titleView = mainTitle
        
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
        
        try? trackerStore.fetchFilteredTrackers(date: currentDate, searchString: searchBarText)
        reloadTrackersCollectionView()
    }
    
    //Methods
    
    @objc func didTapPlusButton() {
        let makeNewTrackerViewController = MakeNewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: makeNewTrackerViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func didChangeDatePicker(_ sender: UIDatePicker) {
        currentDate = sender.date
        try? trackerStore.fetchFilteredTrackers(date: currentDate, searchString: searchBarText)
        reloadTrackersCollectionView()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func reloadTrackersCollectionView() {
        imageView.isHidden = trackerStore.trackers.count > 0
        littleTitle.isHidden = trackerStore.trackers.count > 0
        trackersCollectionView.isHidden = trackerStore.trackers.count == 0
        
        trackersCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionsAmount = trackerStore.fetchedResultsController.sections?.count
        else {
            return 0
        }
        return sectionsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersAmount = trackerStore.fetchedResultsController.sections?[section].numberOfObjects
        else {
            return 0
        }
        return trackersAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell,
            let tracker = trackerStore.getTracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        let daysCount = trackerRecordStore.getTrackerRecordAmount(with: tracker)
        var isDone = false
        if (try? trackerRecordStore.getTrackerRecord(with: tracker.id, date: currentDate)) != nil {
            isDone = true
        }
        
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
        
        if let trackerCoreData = trackerStore.fetchedResultsController.sections?[indexPath.section].objects?.first as? TrackerCoreData {
            view.titleLabel.text = trackerCoreData.category?.label ?? ""
        } else {
            view.titleLabel.text = ""
        }
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
    func didTapCreateButton(_ tracker: Tracker, category: TrackerCategory) {
        
        do {
            try trackerStore.addNewTracker(tracker, with: category)
        } catch {
            print("Error saving context: \(error)")
        }
        trackersCollectionView.reloadData()
    }
}

// MARK: - TrackerCellDelegate
extension TrackerCollectionViewController: TrackerCellDelegate {
    func didTapRoundButton(of cell: TrackerCollectionViewCell, with tracker: Tracker) {
        if currentDate > Date() { return }
        
        let trackerRecord = TrackerRecord(date: currentDate)
        
        if let trackerRecordExisted = try? trackerRecordStore.getTrackerRecord(with: tracker.id, date: currentDate) {
            try? trackerRecordStore.removeTrackerRecord(trackerRecordStore.trackerRecord(from: trackerRecordExisted))
            cell.changeRoundButtonState(isDone: false)

        } else {
            try? trackerRecordStore.addNewTrackerRecord(trackerRecord, with: tracker)
            cell.changeRoundButtonState(isDone: true)
        }
    }
}

// MARK: - TrackerStoreDelegate

extension TrackerCollectionViewController: TrackerStoreDelegate {
    func didUpdate() {
        reloadTrackersCollectionView()
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
