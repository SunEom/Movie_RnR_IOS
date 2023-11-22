//
//  PostCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/09.
//

import Foundation
import RxSwift

struct PostCellViewModel {
    let title: String
    let genres: String
    let overview: String
    let rates: Double
    let commnetNum: Int
}

extension PostCellViewModel {
    init(_ post: Post) {
        self.title = post.title
        self.genres = post.genres
        self.overview = post.overview
        self.rates = post.rates
        self.commnetNum = post.commentCount ?? 0
    }
}
