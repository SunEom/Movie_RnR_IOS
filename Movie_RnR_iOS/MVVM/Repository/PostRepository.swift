//
//  HomeRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import Foundation
import RxSwift
import RxCocoa

struct PostRepository {
    
    func deletePost(postID: Int) -> Observable<RequestResult> {
        return PostNetwork().deletePost(postID: postID)
            .map { result in
                guard case .success = result else { return RequestResult(isSuccess: false, message: "오류가 발생했습니다.")}
                return RequestResult(isSuccess: true, message: "삭제되었습니다!")
            }
            .asObservable()
    }
    
    func createNewPost(title: String, genres: String, rates: Double, overview: String) -> Observable<RequestResult> {
        return PostNetwork().createNewPost(with: (title, genres, rates, overview) )
            .map { result in
                guard case .success = result else { return RequestResult(isSuccess: false, message: "오류가 발생했습니다.")}
                return RequestResult(isSuccess: true, message: "작성되었습니다!")
            }
            .asObservable()
    }
    
    func updatePost(id: Int, title: String, genres: String, rates: Double, overview: String) -> Observable<RequestResult> {
        return PostNetwork().updatePost(with: (id, title, genres, rates, overview))
            .map { result in
                guard case .success = result else { return RequestResult(isSuccess: false, message: "오류가 발생했습니다.")}
                return RequestResult(isSuccess: true, message: "수정되었습니다!")
            }
            .asObservable()
    }
    
    func fetchRecentPostings() -> Observable<[Post]> {
        return PostNetwork().fetchRecentPosts()
            .asObservable()
            .compactMap(parseDataWithTitleCell)
    }
    
    func fetchUserPostings(userID: Int) -> Driver<[Post]> {
        return PostNetwork().fetchUserPostings(userID: userID)
            .asObservable()
            .compactMap(parseData)
            .asDriver(onErrorJustReturn: [])
    }
    
    private func parseDataWithTitleCell(result: Result<PostResponse, NetworkError>) -> [Post] {
        guard case .success(let response) = result else { return [] }
        return [Post(id: 0, title: "", overview: "", created: "", genres: "", rates: 0, updated: "", user_id: 0, commentCount: 0)] + response.data
    }
    
    private func parseData(result: Result<PostResponse, NetworkError>) -> [Post] {
        guard case .success(let response) = result else { return [] }
        return response.data
    }
}
