//
//  CommetListCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import RxCocoa
import RxSwift

struct CommentViewModel {
    private let disposeBag = DisposeBag()
    private let repository: CommentRepository
    private let postID: Int!
    
    struct Input {
        let trigger: Driver<Void>
        let createTrigger: Driver<Void>
        let content: Driver<String>
    }
    
    struct Output {
        let comments: Driver<[Comment]>
        let createResult: Driver<RequestResult>
        let loading: Driver<Bool>
    }
    
    init(postID: Int, repository: CommentRepository = CommentRepository()) {
        self.repository = repository
        self.postID = postID
    }
    
    func transfrom(input: Input) -> Output {
        let loading = PublishSubject<Bool>()
        
        let comments = input.trigger
            .do(onNext: { _ in loading.onNext(true)} )
            .flatMapLatest {
                repository.fetchComment(postID: postID)
                    .do(onNext: { _ in loading.onNext(false)} )
                    .asDriver(onErrorJustReturn: [])
            }
        
        let createResult = input.createTrigger
            .withLatestFrom(Driver.combineLatest(UserManager.getInstance().asDriver(onErrorJustReturn: nil), input.content))
            .do(onNext: { _ in loading.onNext(true)})
            .flatMapLatest { user, content in
                repository.createNewComment(user: user, contents: content)
                    .do(onNext: { _ in loading.onNext(false)})
                    .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))
            }
        
        return Output(comments: comments, createResult: createResult, loading: loading.asDriver(onErrorJustReturn: false))
    }
}
