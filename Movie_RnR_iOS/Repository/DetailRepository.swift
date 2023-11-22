//
//  DetailRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import Foundation
import RxSwift

struct DetailRepository {
    func fetchPostDetail (post: Post) -> Single<PostDetail?> {
        return PostNetwork().fetchPostDetail(postID: post.id)
            .map(parseData)
    }
    
    private func parseData(result: Result<PostDetailRepsonse, NetworkError>) ->PostDetail? {
        guard case .success(let response) = result else { return nil }
        return response.data
    }
}
