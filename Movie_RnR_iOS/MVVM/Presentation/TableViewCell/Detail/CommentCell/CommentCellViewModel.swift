//
//  CommentCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/01.
//

import Foundation
import RxSwift

struct CommentCellViewModel {
    
    let disposeBag = DisposeBag()
    
    var parentViewController: CommentViewController!
    
    let data: Observable<Comment>
    
    let editRequest = PublishSubject<Void>()
    let deleteRequest = PublishSubject<Void>()
    
    init(vc: CommentViewController, comment: Comment) {
        self.parentViewController = vc;
        
        data = Observable.of(comment)
        
        deleteRequest
            .withLatestFrom(data)
            .flatMapLatest { CommentNetwork().deleteComment(commentID: $0.id) }
            .map { result -> (String, String) in
                guard case .success(_) = result else { return ("실패", "댓글 삭제에 실패하였습니다.") }
                return ("성공", "댓글이 정상적으로 삭제되었습니다.")
            }
            .bind(to: parentViewController.viewModel.alert)
            .disposed(by: disposeBag)
            
    }
}
