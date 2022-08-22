//
//  UserPostingViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct UserPostingViewModel {
    
    var userID: Int!
    
    let disposeBag = DisposeBag()
    
    let cellData: Driver<[Post]>
    
    let selectedIdx = PublishSubject<IndexPath>()
    let selectedItem = PublishSubject<Post>()
    
    init(userID: Int, _ repository: PostRepository = PostRepository()) {
        self.userID = userID
        cellData = repository.fetchUserPostings(userID: self.userID)
        
        selectedIdx
            .withLatestFrom(cellData) { idx, posts in
                return posts[idx.row]
            }
            .bind(to: selectedItem)
            .disposed(by: disposeBag)
        
    }
}
