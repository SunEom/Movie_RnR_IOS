//
//  HomeViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct HomeViewModel {
    private let disposeBag = DisposeBag()
    private let repository: PostRepository
    
    struct Input {
        let triger: Driver<Void> // 최근 게시물 요청 트리거
        let selection: Driver<IndexPath> // 특정 게시글 선택 트리거
    }
    
    struct Output {
        let posts: Driver<[Post]> // 최근 게시글 목록
        let selectedPost: Driver<Post> // 선택된 게시글
        let fetching: Driver<Bool> // 로딩 여부
        let login: Driver<Bool> // 로그인 여부
    }

    init(_ repository: PostRepository = PostRepository()) {
        self.repository = repository
    }
    
    func transfrom(input: Input) -> Output {
        let posts = input.triger.flatMapLatest { repository.fetchRecentPostings().asDriver(onErrorJustReturn: []) }
        let selectedPost = input.selection.withLatestFrom(posts) { (indexPath, posts) -> Post in
            return posts[indexPath.row]
        }
        let fetching = posts.map { _ in false }
        let login = UserManager.getInstance().map { $0 != nil }.asDriver(onErrorJustReturn: false)
        
        return Output(posts: posts, selectedPost: selectedPost, fetching: fetching, login: login)
    }
}
