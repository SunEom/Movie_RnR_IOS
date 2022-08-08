//
//  PostDetail.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/19.
//

import Foundation

class PostingDetailResponse: Decodable {
    let code : Int
    let data: PostingDetail
}

class PostingDetail: Decodable {
    let movie: movieData
    let user: userData
    
    class movieData: Decodable {
        let id: Int
        let title: String
        let overview: String
        let created: String
        let genres: String
        let rates: Double
        let updated: String
        let user_id: Int
    }
    
    class userData: Decodable {
        let id: Int
        let nickname: String
    }
}
