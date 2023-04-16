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
    
    var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.backgroundColor = .white
        date.tintColor = .blue
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Поиск"
        view.searchBarStyle = .minimal
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let trackers = ["First_init", "Second_init", "Third_init", "Fourth_init", "Fifth_init", "First_init", "Second_init", "Third_init", "Fourth_init", "Fifth_init"]
//        private let trackers: Array<String> = []
    private var visibleTrackers: Array<String> = []
    private let emojis: Array = {
        let emojiCollection = EmojiCollectionViewController()
        return emojiCollection.emojis
    }()
    
    var trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        setUp()
        applyLayOut()
        checkAvailableTrackers()
        trackersCollectionView.allowsMultipleSelection = false
    }
    
    //Methods
    
    @objc func didTapPlusButton() {
        let makeNewTrackerViewController = MakeNewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: makeNewTrackerViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func checkAvailableTrackers() {
        imageView.isHidden = !trackers.isEmpty
        littleTitle.isHidden = !trackers.isEmpty
        trackersCollectionView.isHidden = trackers.isEmpty
    }
}
 
extension TrackerCollectionViewController {
    func setUp() {
        //Create items
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 182)
        let leftButton = UIBarButtonItem(customView: searchBar)
        navigationBar.topItem?.setLeftBarButton(leftButton, animated: false)
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationBar.topItem?.titleView = mainTitle
        
        visibleTrackers = trackers
        
        //Add subviews
        view.addSubview(plusButton)
        view.addSubview(mainTitle)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        view.addSubview(navigationBar)
        view.addSubview(trackersCollectionView)
        
        searchBar.delegate = self
        
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func applyLayOut() {
        [trackersCollectionView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        // Add constraints
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
}
 
// MARK: - UICollectionViewDataSource
 
extension TrackerCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell
        
        
        cell?.titleLabel.text = visibleTrackers[indexPath.row]
        cell?.emojiLabel.text = emojis.randomElement()
        let color = UIColor(red: .random(in: 0...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1),
                            alpha: 1.0)
        cell?.trackerBackgroundView.backgroundColor = color
        cell?.roundButton.backgroundColor = color
        
        return cell!
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
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = "QQQQQQ"
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor(named: "grey_for_textField")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        cell?.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
 
// MARK: - UISearchBarDelegate
 
extension TrackerCollectionViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        visibleTrackers = trackers.filter({ $0.hasPrefix(searchText) })
        trackersCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        visibleTrackers = trackers
        searchBar.setShowsCancelButton(false, animated: true)
        trackersCollectionView.reloadData()
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
