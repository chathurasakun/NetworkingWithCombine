//
//  ProductDetailViewController.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit
import Combine

class ProductDetailViewController: UIViewController {
    // MARK: - Variables
    let viewModel: ProductDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Components
    private var updateBarButtonItem: UIBarButtonItem!
    
    private let productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .clear
        control.currentPage = 0
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        return control
    }()
    
    private let updatePrizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type here..."
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    // MARK: - LifeCycle
    init(viewModel: ProductDetailViewModel) {
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
    }
    
    deinit {
        print("ProductDetailViewController Deallocated")
    }
    
    // MARK: - Observers
    private func setObservers() {
        viewModel.$productUpdated
            .sink { [weak self] success in
                guard let success = success else {
                    return
                }
                if success {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .clear
        
        title = viewModel.product.title ?? ""
        
        updateBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(onUpdatePrize(_:)))
        navigationItem.rightBarButtonItem = updateBarButtonItem
        
        view.addSubview(productCollectionView)
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 7),
            productCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7),
            productCollectionView.heightAnchor.constraint(equalToConstant: 250),
            productCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7)
        ])
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        productCollectionView.register(
            ProductImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductImageCollectionViewCell.identifier
        )
        
        pageControl.numberOfPages = viewModel.product.images?.count ?? 0
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            pageControl.topAnchor.constraint(equalTo: productCollectionView.bottomAnchor,
                                             constant: 5),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        pageControl.addTarget(self, action: #selector(onPageControlChange(_:)), for: .valueChanged)
        
        let title = viewModel.product.title ?? ""
        let titleLabel = createLable(title: title, fontSize: 18, fontColor: .black, weight: .medium)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7),
            titleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7)
        ])
        
        let brand = viewModel.product.brand ?? ""
        let brandLabel = createLable(title: brand, fontSize: 16, fontColor: .black, weight: .medium)
        view.addSubview(brandLabel)
        NSLayoutConstraint.activate([
            brandLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7),
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            brandLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7)
        ])
        
        let description = viewModel.product.description ?? ""
        let descriptionLabel = createLable(title: description, fontSize: 15, fontColor: .lightGray,
                                           weight: .regular)
        descriptionLabel.numberOfLines = 5
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7),
            descriptionLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7)
        ])
        
        let price = "Rs \(viewModel.product.price ?? 0)/="
        let priceLabel = createLable(title: price, fontSize: 14, fontColor: .gray, weight: .regular)
        view.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7),
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7)
        ])
        
        let discount = "\(viewModel.product.discountPercentage ?? 0.0)%"
        let discountLabel = createLable(title: discount, fontSize: 18, fontColor: .red,
                                     weight: .semibold)
        view.addSubview(discountLabel)
        NSLayoutConstraint.activate([
            discountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7),
            discountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            discountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -7)
        ])
        
        view.addSubview(updatePrizeTextField)
        NSLayoutConstraint.activate([
            updatePrizeTextField.topAnchor.constraint(equalTo: discountLabel.bottomAnchor,
                                                      constant: 10),
            updatePrizeTextField.widthAnchor.constraint(equalToConstant: 200),
            updatePrizeTextField.heightAnchor.constraint(equalToConstant: 44),
            updatePrizeTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7)
        ])
        updatePrizeTextField.layer.cornerRadius = 7
        updatePrizeTextField.delegate = self
        
    }
    
    @objc private func onUpdatePrize(_ sender: UIBarButtonItem) {
        viewModel.updateProduct()
    }
    
    @objc private func onPageControlChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(row: currentPage, section: 0)
        DispatchQueue.main.async {
            self.productCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally,
                                                    animated: true)
        }
    }
    
    private func createLable(title: String, fontSize: CGFloat, fontColor: UIColor,
                             weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = fontColor
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.text = title
        return label
    }
}

// MARK: - UICollection Datasource
extension ProductDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.product.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ProductImageCollectionViewCell {
            let image = viewModel.product.images?[indexPath.row] ?? ""
            collectionViewCell.backgroundColor = .clear
            collectionViewCell.configureCell(image: image)
            return collectionViewCell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - UICollectionView Delegate
extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 240)
    }
}

// MARK: - UITextField Delegate
extension ProductDetailViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let price = textField.text else {
            return
        }
        viewModel.product.price = Int(price)
    }
}
