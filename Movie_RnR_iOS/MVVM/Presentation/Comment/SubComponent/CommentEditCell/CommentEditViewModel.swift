//
//  CommentEditViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/07.
//

import Foundation
import RxSwift
import RxRelay

struct CommentEditViewModel {
    let disposeBag = DisposeBag()
    
    let comment: Comment!
    
    let editRequestResult = PublishSubject<RequestResult>()
    
    let contents = PublishSubject<String>()
    
    let saveButtonTap = PublishSubject<Void>()
    
    
    init(comment: Comment, repository: CommentRepository = CommentRepository()) {
        self.comment = comment
        
        contents.onNext(comment.contents)
        
        saveButtonTap
            .withLatestFrom(contents)
            .filter { $0 == "" }
            .map { _ in RequestResult(isSuccess: false, message: "댓글의 내용을 입력해주세요.") }
            .bind(to: editRequestResult)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(contents)
            .filter { $0 != "" }
            .flatMapLatest { repository.updateComment(commentId: comment.id, contents: $0) }
            .bind(to: editRequestResult)
            .disposed(by: disposeBag)
        
    }
}
