//
//  TrackerCollectionViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 07/04/2023.
//

import UIKit

class TrackerCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    private let analyticsService = AnalyticsService()
    
    var plusButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plusIcon")!,
            target: self,
            action: #selector(didTapPlusButton)
        )
        button.tintColor = UIColorMarshalling.toggleBlackWhiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var mainTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("trackers", comment: "Text displayed on title")
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = UIColorMarshalling.toggleBlackWhiteColor
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
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
        collection.backgroundColor = .clear
        collection.allowsMultipleSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collection.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(named: "blue_YP")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var searchBarText: String = "" {
        didSet {
            try? trackerStore.fetchFilteredTrackers(date: currentDate, searchString: searchBarText)
            reloadTrackersCollectionView()
        }
    }
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private var trackerStore: TrackerStoreProtocol
    
    
    override func viewDidLoad() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        //Create items
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 182)
        let leftButton = UIBarButtonItem(customView: searchBar)
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationBar.topItem?.titleView = mainTitle
        
        trackerStore.delegate = self
        
        //Add subviews
        view.addSubview(plusButton)
        view.addSubview(mainTitle)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        view.addSubview(navigationBar)
        view.addSubview(trackersCollectionView)
        view.addSubview(filterButton)
        
        view.backgroundColor = UIColor(named: "background_screen")
        
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
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        try? trackerStore.fetchFilteredTrackers(date: currentDate, searchString: searchBarText)
        reloadTrackersCollectionView()
    }
    
    // MARK: - LifeCycle
    init(trackerStore: TrackerStoreProtocol) {
        self.trackerStore = trackerStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Methods
    
    @objc func didTapPlusButton() {
        analyticsService.reportEvent(event: .click, screen: .main, item: .addTrack)
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
        imageView.isHidden = trackerStore.getTrackersAmount() > 0
        littleTitle.isHidden = trackerStore.getTrackersAmount() > 0
        filterButton.isHidden = trackerStore.getTrackersAmount() == 0
        trackersCollectionView.isHidden = trackerStore.getTrackersAmount() == 0
        
        trackersCollectionView.reloadData()
    }
    
    private func pinTracker(_ tracker: Tracker) {
        do {
            try trackerStore.changePin(for: tracker)
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    private func editTracker(_ tracker: Tracker, category: TrackerCategory) {
        analyticsService.reportEvent(event: .click, screen: .main, item: .edit)
        
        let newBehaviorViewController = NewBehaviorViewController(eventType: "Editing", editingTracker: tracker, trackerCategory: category)
        newBehaviorViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newBehaviorViewController)
        newBehaviorViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func deleteTracker(_ tracker: Tracker) {
        do {
            try trackerStore.deleteTracker(tracker)
            analyticsService.reportEvent(event: .click, screen: .main, item: .delete)
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    @objc
    private func didTapFilterButton() {
        analyticsService.reportEvent(event: .click, screen: .main, item: .filter)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.getCategoriesAmount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.getTrackersAmountPerSection(section: section)
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
        
        let interaction = UIContextMenuInteraction(delegate: self)
        
        cell.configure(tracker: tracker, days: daysCount, isDone: isDone, interaction: interaction)
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
        
        view.titleLabel.text = trackerStore.getCategoryLabel(section: indexPath.section)
        view.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 19.0)
        return view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.reportScreen(event: .open, onScreen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.reportScreen(event: .close, onScreen: .main)
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension TrackerCollectionViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let location = interaction.view?.convert(location, to: trackersCollectionView),
            let indexPath = trackersCollectionView.indexPathForItem(at: location),
            let tracker = trackerStore.getTracker(at: indexPath)
        else { return nil }
        
        let pinTitle = tracker.isPinned ? "Открепить" : "Закрепить"
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            UIMenu(title: "", children: [
                UIAction(title: pinTitle, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off) { [weak self] _ in
                    self?.pinTracker(tracker)
                },
                UIAction(title: "Редактировать", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { [weak self] _ in
                    guard
                        let categoryLabel = self?.trackerStore.getCategoryLabel(section: indexPath.section),
                        let trackerCategory = self?.trackerCategoryStore.getTrackerCategory(by: categoryLabel)
                    else { return }
                    self?.editTracker(tracker, category: trackerCategory)
                },
                UIAction(title: "Удалить", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { [weak self] _ in
                    self?.deleteTracker(tracker)
                }
            ])
        })
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
    
    func didTapSaveButton(_ tracker: Tracker, with newData: Tracker, category: TrackerCategory) {
        do {
            try trackerStore.updateTracker(tracker, with: newData, trackerCategory: category)
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
