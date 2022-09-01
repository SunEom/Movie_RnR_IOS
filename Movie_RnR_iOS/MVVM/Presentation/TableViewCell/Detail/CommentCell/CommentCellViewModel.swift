//
//  CommentCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/01.
//

import Foundation
import RxSwift

struct CommentCellViewModel {
    let data: Observable<Comment>
    
    init(comment: Comment) {
        data = Observable.of(comment)
    }
}
