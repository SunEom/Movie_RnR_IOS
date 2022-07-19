//
//  Comment.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import Foundation

class CommentResponse: Decodable {
    let code: Int
    let data: [Comment]
}

class Comment: Decodable {
    let id: Int
    let contents: String
    let created: String
    let commenter: Int
    let movie_id: Int
    let nickname: String
}
