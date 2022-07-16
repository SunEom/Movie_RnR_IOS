//
//  Post.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/17.
//

import Foundation

class Post: Decodable {
    let id: Int
    let title: String
    let overview: String
    let created: String
    let genres: String
    let rate: Double
    let updated: String
    let user_id: Int
    let commentCount: Int?
}
