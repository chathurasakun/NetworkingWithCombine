//
//  ProductListViewController.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import UIKit
import Combine

protocol ProductListViewControllerProtocol: AnyObject {
    func logoutFromApp()
}

class ProductListViewController: UIViewController {
    // MARK: - Variables
    let viewModel: ProductListViewModel
    weak var delegate: ProductListViewControllerProtocol?
    private var cancellables: Set<AnyCancellable> = []
    private var productAvailabilityWorkItem: DispatchWorkItem?
    
    // MARK: - Components
    private var logoutBarButtonItem: UIBarButtonItem!
    
    private let searchController: UISearchController = {
        let searchbox = UISearchController(searchResultsController: nil)
        searchbox.obscuresBackgroundDuringPresentation = false
        searchbox.searchBar.placeholder = "Type something here to search..."
        return searchbox
    }()
    
    private let productListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = true
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setObservers()
        viewModel.getAllProducts()
    }
    
    deinit {
        print("ProductListViewController Deallocated")
    }
    
    // MARK: - Set Combine Observers
    private func setObservers() {
        viewModel.$productsRecieved
            .sink { [weak self] success in
                guard let success = success else {
                    return
                }
                if success {
                    DispatchQueue.main.async {
                        self?.productListTableView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    private func setUpUI() {
        view.backgroundColor = .white
        
        logoutBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self,
                                              action: #selector(logout(_:)))
        navigationItem.rightBarButtonItem = logoutBarButtonItem
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        view.addSubview(productListTableView)
        NSLayoutConstraint.activate([
            productListTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            productListTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            productListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            productListTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        ])
        productListTableView.delegate = self
        productListTableView.dataSource = self
        
        productListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "productCell")
    }
    
    @objc private func logout(_ sender: UIBarButtonItem) {
        delegate?.logoutFromApp()
    }

}

// MARK: - Search Results Delegate
extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        productAvailabilityWorkItem?.cancel()
        guard let searchQuery = searchController.searchBar.text else {
            return
        }
        
        let workItem: DispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.searchProduct(queryString: searchQuery)
        }
        productAvailabilityWorkItem = workItem
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: workItem)
    }
}

// MARK: - UITableView DataSource
extension ProductListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                        for: indexPath)
        productCell.textLabel?.text = viewModel.products[indexPath.row].title
        productCell.backgroundColor = .clear
        productCell.selectionStyle = .none
        return productCell
    }
}

// MARK: - UITableView DataSource
extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(viewModel.products[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(viewModel.products[indexPath.row])
    }
}
