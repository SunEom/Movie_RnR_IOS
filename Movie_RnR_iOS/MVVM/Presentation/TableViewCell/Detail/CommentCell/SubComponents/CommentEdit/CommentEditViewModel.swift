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
    
    let alert = PublishSubject<(String, String)>()
    
    let contents = PublishSubject<String>()
    
    let saveButtonTap = PublishSubject<Void>()
    
    
    init(comment: Comment) {
        self.comment = comment
        
        contents.onNext(comment.contents)
        
        saveButtonTap
            .withLatestFrom(contents)
            .filter { $0 == "" }
            .map { _ in ("실패", "댓글의 내용을 입력해주세요.") }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(contents)
            .filter { $0 != "" }
            .flatMapLatest { CommentNetwork().updateComment(with: (comment.id, $0)) }
            .map { result -> (String, String) in
                print(result)
                guard case .success(_) = result else { return ("실패", "댓글 수정에 실패하였습니다.\n잠시후 다시 시도해주세요.")}
                return ("성공"," 정상적으로 수정되었습니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
    }
}
