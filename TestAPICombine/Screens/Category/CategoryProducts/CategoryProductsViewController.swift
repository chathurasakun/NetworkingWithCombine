//
//  CategoryProductsViewController.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit
import Combine

class CategoryProductsViewController: UIViewController {
    // MARK: - Varaiables
    let viewModel: CategoryProductsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Components
    private let productListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - LifeCycle
    init(viewModel: CategoryProductsViewModel) {
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
        viewModel.getProductsOfCategory()
    }
    
    deinit {
        print("CategoryProductsViewController Deallocated")
    }
    
    // MARK: - Observers
    private func setObservers() {
        viewModel.$productsRecieved
            .sink { [weak self] success in
                guard let success = success else {
                    return
                }
                if success {
                    DispatchQueue.main.async {
                        self?.productListCollectionView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        title = viewModel.category
        view.backgroundColor = .white
        
        view.addSubview(productListCollectionView)
        NSLayoutConstraint.activate([
            productListCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            productListCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            productListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                              constant: 0),
            productListCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        
        productListCollectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.idebtifier
        )
    }

}

// MARK: - UICollection Datasource
extension CategoryProductsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.idebtifier,
            for: indexPath
        ) as? ProductCollectionViewCell {
            let product = viewModel.products[indexPath.row]
            collectionViewCell.backgroundColor = .clear
            collectionViewCell.configureCell(product: product)
            return collectionViewCell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionView Delegate
extension CategoryProductsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let productDetailViewModel = ProductDetailViewModel(apiClient: ApiClient(),
                                                            product: product)
        let productDetailViewController = ProductDetailViewController(
            viewModel: productDetailViewModel
        )
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 220)
    }
}
