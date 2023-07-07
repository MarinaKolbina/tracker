//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 26/06/2023.
//

import UIKit

protocol CategoriesViewDelegate: AnyObject {
}

class CategoriesViewController: UIViewController {
    
    
    weak var delegate: CategoriesViewDelegate?
    private var viewModel: CategoriesViewModel
    var provideSelectedCategory: ((TrackerCategory) -> Void)?
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        table.backgroundColor = UIColor(named: "grey_for_days")
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var addNewCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Добавить категорию", for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddNewCategoryButton), for: .touchUpInside)
        return button
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "starIcon"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var littleTitle: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "Привычки и события можно объединить по смыслу"
        titleImage.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        titleImage.textColor = .black
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Категория"
        
        view.addSubview(tableView)
        view.addSubview(addNewCategoryButton)
        view.addSubview(imageView)
        view.addSubview(littleTitle)
        
        let tableHeight = 75 * viewModel.countCategories()
                    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(tableHeight)),
            
            addNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addNewCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            littleTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            littleTitle.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 60)
        ])
        
        hideExtras()
    }
    
    @objc func didTapAddNewCategoryButton() {
        
        let makeNewCategoryViewController = MakeNewCategoryViewController(title: "Новая категория")
        makeNewCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: makeNewCategoryViewController)
        makeNewCategoryViewController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func hideExtras() {
        imageView.isHidden = viewModel.countCategories() > 0
        littleTitle.isHidden = viewModel.countCategories() > 0
        tableView.isHidden = viewModel.countCategories() == 0
        tableView.reloadData()
    }
    
    private func editCategory(_ category: TrackerCategory) {
        let editCategoryViewController = MakeNewCategoryViewController(title: "Редактирование категории")
        editCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: editCategoryViewController)
        present(navigationController, animated: true)
    }
    
    private func deleteCategory(_ category: TrackerCategory) {
        let alert = UIAlertController(
            title: nil,
            message: "Эта категория точно не нужна?",
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(category)
            
            self?.hideExtras()
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell,
            let category = viewModel.getCategory(at: indexPath)
        else {
            return UITableViewCell()
        }

        cell.configure(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
//            viewModel.selectCategory(indexPath: indexPath)
//            provideSelectedCategory?(viewModel.selectedCategory!)
            guard
                let category = viewModel.getCategory(at: indexPath)
            else { return }
            provideSelectedCategory?(category)
//            provideSelectedCategory?(viewModel.getCategory(at: indexPath))
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let category = viewModel.getCategory(at: indexPath)
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editCategory(category!)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.deleteCategory(category!)
                }
            ])
        })
    }
}
 
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoriesViewController: MakeNewCategoryViewControllerDelegate {
    func didTapReadyButton(label: String) {
        viewModel.addNewCategory(TrackerCategory(label: label))
        hideExtras()
//        tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * viewModel.countCategories()))
        dismiss(animated: true)
    }
}
