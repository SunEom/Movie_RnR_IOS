//
//  HomeViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct HomeViewModel {
    let disposeBag = DisposeBag()
    
    let cellData: Driver<[Post]>
    let itemSelected = PublishSubject<Int>()
    let selectedItem: Driver<Post?>
    
    let logined = BehaviorSubject<Bool>(value: false)

    init(_ repository: PostRepository = PostRepository()) {
        cellData = repository.fetchRecentPostings()
        
        selectedItem = itemSelected
            .withLatestFrom(cellData) { idx, list in
                list[idx]
            }
            .asDriver(onErrorJustReturn: nil)
    }
}
