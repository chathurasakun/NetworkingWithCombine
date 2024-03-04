//
//  ProductImageCollectionViewCell.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductImageCollectionViewCell"
    
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
    
    // MARK: - LifeCycle
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
            baseView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            baseView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            baseView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        ])
        baseView.dropShadow(opacity: 0.12, shadowRadius: 7)
        
        baseView.addSubview(productImage)
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            productImage.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: 0),
            productImage.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            productImage.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 0),
        ])
        productImage.layer.cornerRadius = 7
    }
    
    func configureCell(image: String) {
        if let imageURL = URL(string: image) {
            productImage.load(url: imageURL)
        }
    }
}
