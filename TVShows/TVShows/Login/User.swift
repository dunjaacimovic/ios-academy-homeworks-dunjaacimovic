//
//  User.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
struct LoginData: Codable {
    let token: String
}

struct RememberedUser: Codable {
    let email: String
    let password: String
}
