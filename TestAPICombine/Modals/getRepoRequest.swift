//
//  getRepoRequest.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation

struct GetRepoRequest: Codable, DictionaryConvertor {
    var q: String
    var per_page: Int
    var page: Int
    
//    enum CodingKeys: String, CodingKey {
//        case query = "q"
//        case perPage = "per_page"
//        case page = "page"
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.query = try container.decode(String.self, forKey: .query)
//        self.perPage = try container.decode(Int.self, forKey: .perPage)
//        self.page = try container.decode(Int.self, forKey: .page)
//    }
}

//extension GetRepoRequest {
//    func encode(to encoder: Encoder) throws {
//        var conatiner = encoder.container(keyedBy: CodingKeys.self)
//        try conatiner.encode(query, forKey: .query)
//        try conatiner.encode(perPage, forKey: .perPage)
//        try conatiner.encode(page, forKey: .page)
//    }
//}
