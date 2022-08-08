//
//  HomeViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct HomeViewModel {
    let cellData: Driver<[Post]>

    init(_ repository: HomeRepository = HomeRepository()) {
        cellData = repository.fetchRecentPostings()
    }
}
