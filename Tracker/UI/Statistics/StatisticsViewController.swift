//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 23/07/2023.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource {
    
    private var viewModel: StatisticsViewModel
    let uiColorMarshalling = UIColorMarshalling()

    var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Статистика"
        title.font = UIFont(name:"HelveticaNeue-Bold", size: 34.0)
        title.textColor = UIColorMarshalling.toggleBlackWhiteColor
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cryIcon"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var littleTitle: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "Анализировать пока нечего"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = UIColorMarshalling.toggleBlackWhiteColor
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            StatisticCell.self,
            forCellReuseIdentifier: StatisticCell.identifier
        )
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(mainTitle)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor(named: "background_screen")
        
        NSLayoutConstraint.activate([
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitle.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88),
            
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            littleTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            littleTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 77),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 408)
        ])
        
        bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startObserve()
    }
    
    private func bindingViewModel() {
        viewModel.$statusEmptyImage.bind { [weak self] statusEmptyImage in
            self?.showTable(!statusEmptyImage)
        }
        
        viewModel.$bestPeriod.bind { [weak self] newValue in
            self?.updateCellModel(for: .bestPeriod, value: newValue)
        }
        viewModel.$perfectDays.bind { [weak self] newValue in
            self?.updateCellModel(for: .perfectDays, value: newValue)
        }
        viewModel.$completedTrackers.bind { [weak self] newValue in
            self?.updateCellModel(for: .completedTrackers, value: newValue)
        }
        viewModel.$mediumValue.bind { [weak self] newValue in
            self?.updateCellModel(for: .mediumValue, value: newValue)
        }
    }
    
    private func updateCellModel(for statisticsCase: StatisticsCases, value: Int) {
        let cellModel = StatisticsCellModel(value: String(value), description: statisticsCase.description)
        
        if let index = viewModel.cellModels.firstIndex(where: { $0.description == statisticsCase.description }) {
            viewModel.cellModels[index] = cellModel
        } else {
            print("smth go wrong with statystics cells")
//            viewModel.cellModels.append(cellModel)
        }
        tableView.reloadData()
    }
    
    private func showTable(_ show: Bool) {
        imageView.isHidden = show
        littleTitle.isHidden = show
        tableView.isHidden = !show
    }
}

extension StatisticsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StatisticsCases.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell else { return UITableViewCell() }
        
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.configureCell(with: cellModel)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
}
