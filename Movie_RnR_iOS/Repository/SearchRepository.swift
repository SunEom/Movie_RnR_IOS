//
//  SearchRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchRepository {
    
    func searchPostings(query: String?) -> Observable<[Post]> {
        return PostNetwork().searchPosts(query: query ?? "")
            .asObservable()
            .compactMap(parseData)
    }
    
    private func parseData(result: Result<PostResponse, NetworkError>) -> [Post] {
        guard case .success(let response) = result else { return [] }
        return response.data
    }
}
