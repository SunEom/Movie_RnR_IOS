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
    let itemSelected = PublishSubject<Int>()
    let selectedItem: Driver<Post?>
    
    init(_ repository: SearchRepository = SearchRepository()) {
        
        cellData = keyword
            .filter { query in
                return query != nil && query != ""
            }
            .flatMapLatest(repository.searchPostings)
            .asDriver(onErrorJustReturn: [])
            
        selectedItem = itemSelected
            .withLatestFrom(cellData) { idx, list in
                list[idx]
            }
            .asDriver(onErrorJustReturn: nil)
    }
}
