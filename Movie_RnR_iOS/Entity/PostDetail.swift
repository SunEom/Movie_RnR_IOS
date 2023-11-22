//
//  PostDetail.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/11.
//

import Foundation

struct PostDetailRepsonse: Decodable {
    let code: Int
    let data: PostDetail
}

struct PostDetail: Decodable {
    let movie: Post
    let user: PostUserData
}

struct PostUserData: Decodable {
    let id: Int
    let nickname: String
}
