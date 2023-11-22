//
//  UserPostingViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct UserPostingViewModel {
    private var userID: Int!
    private let disposeBag = DisposeBag()
    private let repository: PostRepository
    
    struct Input {
        let selected: Driver<IndexPath>
    }
    
    struct Output {
        let posts: Driver<[Post]>
        let selectedPost: Driver<Post>
    }
    
    init(userID: Int, _ repository: PostRepository = PostRepository()) {
        self.userID = userID
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        let posts = repository.fetchUserPostings(userID: userID)
            .asDriver()
        let selectedPost = input.selected.withLatestFrom(posts) { indexPath, list in list[indexPath.row] }.asDriver()
        
        return Output(posts: posts, selectedPost: selectedPost)
    }
}
