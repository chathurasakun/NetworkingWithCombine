//
//  Repo.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation

struct Repo: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case htmlURL = "html_url"
        case language
       }

    let id = UUID()
    let name: String
    let owner: Owner
    let htmlURL: String
    let language: String?
}
