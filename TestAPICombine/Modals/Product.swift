//
//  Product.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-02.
//

import Foundation

struct Product: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Int?
    var discountPercentage: Double?
    var rating: Double?
    var stock: Int?
    var brand: String?
    var category: String?
    var thumbnail: String?
    var images: [String]?
}
