//
//  LoginResponse.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-02.
//

import Foundation

struct LoginResponse: Codable {
    let id: Int?
    let username: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let image: String?
    let token: String?
}
