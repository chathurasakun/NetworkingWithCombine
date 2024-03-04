//
//  ProductCollectionViewCell.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    static let idebtifier = "ProductCollectionViewCell"
    
    // MARK: - Components
    private let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        backgroundColor = .clear
        
        addSubview(baseView)
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2)
        ])
        baseView.dropShadow(opacity: 0.12, shadowRadius: 7)
        baseView.layer.cornerRadius = 7
        
        addSubview(productImage)
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 7),
            productImage.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -7),
            productImage.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 7),
            productImage.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 7),
            titleLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 7),
            titleLabel.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -7)
        ])
        
        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 7),
        ])

    }
    
    func configureCell(product: Product) {
        if let productThumbnail = product.thumbnail {
            if let thumbinailURL = URL(string: productThumbnail) {
                productImage.load(url: thumbinailURL)
            }
        }
        if let title = product.title {
            titleLabel.text = title
        }
        if let price = product.price {
            priceLabel.text = "\(price)"
        }
    }
    
}
