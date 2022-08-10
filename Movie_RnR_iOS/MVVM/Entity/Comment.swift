//
//  Comment.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import Foundation

struct CommentResponse: Decodable {
    let code: Int
    let data: [Comment]
}

struct Comment: Decodable {
    let id : Int
    let contents: String
    let created: String
    let updated: String
    let commenter: Int
    let movie_id: Int
    let nickname: String
    
}
