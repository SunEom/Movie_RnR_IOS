//
//  CommentCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/01.
//
import Foundation
import RxSwift

class CommentCellViewModel {
    
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
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(_):
                        self.parentViewController.viewModel.fetchComment.onNext(Void())
                        self.parentViewController.viewModel.deleteCommentRequestResult.onNext(CommentNetworkResult(isSuccess: true, message: nil))
                    case .failure(let error):
                        self.parentViewController.viewModel.deleteCommentRequestResult.onNext(CommentNetworkResult(isSuccess: false, message: error.rawValue))
                        
                }
            })
            .disposed(by: disposeBag)
            
    }
}
