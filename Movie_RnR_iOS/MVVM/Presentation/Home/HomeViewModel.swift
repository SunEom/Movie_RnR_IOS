//
//  HomeViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct HomeViewModel {
    let cellData: Driver<[Post?]>

    init() {
        
        cellData = PostNetwork().fetchRecentPosts()
            .map { result -> [Post] in
                guard case .success(let response) = result else { return [] }
                return [Post(id: 0, title: "", overview: "", created: "", genres: "", rates: 0, updated: "", user_id: 0, commentCount: 0)] + response.data
            }
            .asDriver(onErrorJustReturn: [])
            
    }
}
