//
//  CategoryListViewController.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit
import Combine

class CategoryListViewController: UIViewController {
    // MARK: - Varaibles
    let viewModel: CategoryListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    weak var coordinator: CategoryCoordinator?
    
    // MARK: - Components
    private let categoryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

       setUpUI()
       setObservers()
       viewModel.getAllCategories()
    }
    
    init(viewModel: CategoryListViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CategoryListViewController Deallocated")
    }
    
    // MARK: - Set Combine Observers
    private func setObservers() {
        viewModel.$categoriesRecieved
            .sink { [weak self] success in
                guard let success = success else {
                    return
                }
                if success {
                    DispatchQueue.main.async {
                        self?.categoryListTableView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - setUp UI
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(categoryListTableView)
        NSLayoutConstraint.activate([
            categoryListTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            categoryListTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            categoryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            categoryListTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        ])
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
        
        categoryListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
    }

}

// MARK: - UITableView DataSource
extension CategoryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                        for: indexPath)
        productCell.textLabel?.text = viewModel.categories[indexPath.row]
        productCell.backgroundColor = .clear
        productCell.selectionStyle = .none
        return productCell
    }
}

// MARK: - UITableView DataSource
extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        coordinator?.goToProductListPage(category: category)
    }
}
