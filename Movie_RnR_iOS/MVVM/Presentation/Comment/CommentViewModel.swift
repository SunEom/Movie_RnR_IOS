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
    
    let createCommentRequestResult = PublishSubject<CommentNetworkResult>()
    let deleteCommentRequestResult = PublishSubject<CommentNetworkResult>()
    
    let fetchComment = PublishSubject<Void>()
    
    init(postID: Int) {
        
        self.postID = postID
        
        fetchComment
            .flatMapLatest {
                CommentNetwork().fetchComments(postID: postID)
            }
            .compactMap { result -> [Comment] in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .asObservable()
            .bind(to: cellData)
            .disposed(by: disposeBag)
        
        fetchComment.onNext(Void()) // 최초 댓글 조회
        
        saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 == "" }
            .map { _ in
                return CommentNetworkResult(isSuccess: false, message: "댓글의 내용을 입력해주세요.")
            }
            .bind(to: createCommentRequestResult)
            .disposed(by: disposeBag)
        
        saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 != "" }
            .map { (postID, $0) }
            .flatMapLatest({ (id, contents) in
                CommentNetwork().createNewComment(with: (id, contents))
            })
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(_):
                        self.createCommentRequestResult
                            .onNext(CommentNetworkResult(isSuccess: true, message: nil))
                        
                        self.fetchComment.onNext(Void())
                        
                    case .failure(let error):
                        self.createCommentRequestResult
                            .onNext(CommentNetworkResult(isSuccess: false, message: error.rawValue))
                }
            })
            .disposed(by: disposeBag)
        
    }
}

struct CommentNetworkResult {
    let isSuccess: Bool
    let message: String?
}
