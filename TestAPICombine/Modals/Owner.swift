//
//  Owner.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation

struct Owner: Codable {

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }

    let avatarURL: String?
}
