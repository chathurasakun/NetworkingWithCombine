//
//  Products.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-02.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}
