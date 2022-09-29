//
//  CommentRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/29.
//

import Foundation
import RxSwift

struct CommentRepository {
    func fetchComment(postID: Int) -> Observable<[Comment]> {
        return CommentNetwork()
            .fetchComments(postID: postID)
            .compactMap { result -> [Comment] in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .asObservable()
    }
    
    func createNewComment(id: Int, contents: String) -> Observable<RequestResult> {
        return CommentNetwork().createNewComment(with: (id, contents))
            .compactMap{ result in
                switch result {
                    case .success(_):
                        return RequestResult(isSuccess: true, message: nil)
                        
                    case.failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                }
            }
            .asObservable()
    }
    
    func updateComment(commentId: Int, contents: String) -> Observable<RequestResult> {
        return CommentNetwork().updateComment(with: (commentId, contents))
            .compactMap { result in
                switch result {
                    case .success(_):
                        return RequestResult(isSuccess: true, message: nil)
                        
                    case .failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                        
                }
            }
            .asObservable()
    }
    
    func deleteComment(commentId: Int) -> Observable<RequestResult> {
        return CommentNetwork().deleteComment(commentID: commentId)
            .compactMap { result in
                switch result {
                    case .success(_):
                        return RequestResult(isSuccess: true, message: nil)
                    case .failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                }
            }
            .asObservable()
    }
}
