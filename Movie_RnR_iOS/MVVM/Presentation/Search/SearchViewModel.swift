//
//  SearchViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct SearchViewModel {
    let keyword = PublishSubject<String?>()
    
    let cellData: Driver<[Post]>
    
    init() {
        
        cellData = keyword
            .filter { query in
                return query != nil && query != ""
            }
            .flatMapLatest { query in
                return PostNetwork().searchPosts(query: query!)
            }
            .map { result in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .asDriver(onErrorJustReturn: [])
        
            
    }
}
