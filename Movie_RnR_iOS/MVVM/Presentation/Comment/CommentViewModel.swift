//
//  CommetListCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import RxCocoa
import RxSwift

struct CommentViewModel {
    let disposeBag = DisposeBag()
    
    let postID: Int!
    
    let cellData = PublishSubject<[Comment]>()
    
    let content = BehaviorSubject<String>(value: "")
    let saveButotnTap = PublishSubject<Void>()
    
    let alert = PublishSubject<(title: String, message: String)>()
    
    let refresh = PublishSubject<Void>()
    
    init(postID: Int) {
        self.postID = postID
        
        refresh
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
        
        saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 == "" }
            .map { _ in
                return ("실패", "댓글의 내용을 입력해주세요")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        let sendCommentRequest = saveButotnTap
            .withLatestFrom(content.asObservable())
            .filter { $0 != "" }
            .map { (postID, $0) }
            .flatMapLatest({ (id, contents) in
                CommentNetwork().createNewComment(with: (id, contents))
            })
        
        
        // 댓글 작성 실패시에만 알림 발생
//        sendCommentRequest
//            .filter { result in
//                guard case .success(_) = result else { return true }
//                return false
//            }
//            .map { _ in
//                ("실패" , "댓글 작성에 실패하였습니다.")
//            }
//            .bind(to: alert)
//            .disposed(by: disposeBag)
        
        
        sendCommentRequest
            .filter { result in
                guard case .success(_) = result else { return false }
                return true
            }
            .map { _ in
                Void()
            }
            .bind(to: refresh)
            .disposed(by: disposeBag)
        
        
        
    }
}
