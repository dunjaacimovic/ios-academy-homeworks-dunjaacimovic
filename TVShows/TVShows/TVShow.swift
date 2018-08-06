//
//  TVShow.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import Foundation

struct TVShow: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}

struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
    }
}

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}

struct Media: Codable{
    let path: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id = "_id"
    }
}

struct Comment: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}


struct CommentPostResponse: Codable {
    let text: String
    let episodeId: String
    let userId: String
    let userEmail: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userId
        case userEmail
        case type
        case id = "_id"
    }
}
