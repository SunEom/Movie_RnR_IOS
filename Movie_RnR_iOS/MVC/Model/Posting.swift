//
//  Post.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/17.
//

import Foundation

class PostingResponse: Decodable {
    let code: Int
    let data: [Posting]
}

class Posting: Decodable {
    let id: Int
    let title: String
    let overview: String
    let created: String
    let genres: String
    let rates: Double
    let updated: String
    let user_id: Int
    let commentCount: Int?
}
