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
    
    private func parseDataWithTitleCell(result: Result<PostResponse, PostNetworkError>) -> [Post] {
        guard case .success(let response) = result else { return [] }
        return [Post(id: 0, title: "", overview: "", created: "", genres: "", rates: 0, updated: "", user_id: 0, commentCount: 0)] + response.data
    }
    
    private func parseData(result: Result<PostResponse, PostNetworkError>) -> [Post] {
        guard case .success(let response) = result else { return [] }
        return response.data
    }
}
