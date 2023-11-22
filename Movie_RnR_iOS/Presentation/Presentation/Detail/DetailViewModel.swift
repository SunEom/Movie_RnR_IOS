//
//  DetailViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct DetailViewModel {
    private let disposeBag = DisposeBag()
    private let repository: DetailRepository
    private let post: Post

    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let isMine: Driver<Bool>
        let postDetail: Driver<PostDetail?>
        let post: Post
        let loading: Driver<Bool>
    }
    
    init(_ post: Post, _ repository: DetailRepository = DetailRepository()) {
        self.post = post
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        let loading = BehaviorSubject(value: true)
        
        let isMine = UserManager.getInstance().map { user in
            if user == nil {
                return false
            } else {
                return user!.id == post.user_id
            }
        }.asDriver(onErrorJustReturn: false)
        
        let postDetail = input.trigger
            .do(onNext: { loading.onNext(true) })
            .flatMapLatest {
                repository.fetchPostDetail(post: post)
                    .do(onSuccess: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: nil)
            }
        
        return Output(isMine: isMine, postDetail: postDetail, post: post, loading: loading.asDriver(onErrorJustReturn: true))
    }
}
