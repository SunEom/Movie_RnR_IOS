//
//  CommetListCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import RxCocoa
import RxSwift

class CommentViewModel {
    let disposeBag = DisposeBag()
    
    let postID: Int!
    
    let cellData = PublishSubject<[Comment]>()
    
    let content = BehaviorSubject<String>(value: "")
    
    let saveButotnTap = PublishSubject<Void>()
    
    let createCommentRequestResult = PublishSubject<RequestResult>()
    let deleteCommentRequestResult = PublishSubject<RequestResult>()
    
    let fetchComment = PublishSubject<Void>()
    
    init(postID: Int, repository: CommentRepository = CommentRepository()) {
        
        self.postID = postID
        
        fetchComment
            .flatMapLatest{ repository.fetchComment(postID: self.postID) }
            .bind(to: cellData)
            .disposed(by: disposeBag)
        
        fetchComment.onNext(Void()) // 최초 댓글 조회
        
        saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 == "" }
            .map { _ in
                return RequestResult(isSuccess: false, message: "댓글의 내용을 입력해주세요.")
            }
            .bind(to: createCommentRequestResult)
            .disposed(by: disposeBag)
        
        saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 != "" }
            .map { (postID, $0) }
            .flatMapLatest(repository.createNewComment)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.fetchComment.onNext(Void())
                }
                self.createCommentRequestResult.onNext(result)
            })
            .disposed(by: disposeBag)
        
    }
}
