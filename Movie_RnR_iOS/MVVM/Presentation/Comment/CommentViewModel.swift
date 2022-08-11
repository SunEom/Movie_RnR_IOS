//
//  CommetListCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import RxCocoa
import RxSwift

struct CommentViewModel {
    
    let postID: Int?
    
    let cellData: Driver<[Comment]>
    
    init(postID: Int) {
        self.postID = postID
        
        cellData = CommentNetwork().fetchComments(postID: postID)
            .compactMap { result in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .asDriver(onErrorJustReturn: [])
    }
}
