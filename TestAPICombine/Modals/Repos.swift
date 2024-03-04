//
//  Repos.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation

struct Repos: Codable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    let totalCount: Int?
    let items: [Repo]
}
