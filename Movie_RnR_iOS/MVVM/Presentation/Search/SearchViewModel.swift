//
//  SearchViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct SearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: SearchRepository
    
    struct Input {
        let keyword: Driver<String>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let posts: Driver<[Post]>
        let selected: Driver<Post>
    }
    
    init(_ repository: SearchRepository = SearchRepository()) {
        self.repository = repository
    }
    
    func transfrom(input: Input) -> Output {
        
        let posts = input.keyword.filter { $0 != "" }
            .flatMapLatest { repository.searchPostings(query: $0).asDriver(onErrorJustReturn: []) }
            
        let selected = input.selection.withLatestFrom(posts) { indexPath, posts in posts[indexPath.row] }
        
        return Output(posts: posts, selected: selected)
    }
}
