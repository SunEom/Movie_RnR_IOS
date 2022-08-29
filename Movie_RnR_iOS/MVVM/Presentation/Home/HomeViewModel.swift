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
    
    let cellData =  PublishSubject<[Post]>()
    let itemSelected = PublishSubject<Int>()
    let selectedItem: Driver<Post?>
    let newPostButtonTap = PublishSubject<Void>()
    
    let logined = BehaviorSubject<Bool>(value: false)
    
    let refresh = PublishSubject<Void>()

    init(_ repository: PostRepository = PostRepository()) {
        
        refresh
            .flatMapLatest{ repository.fetchRecentPostings() }
            .bind(to: cellData)
            .disposed(by: disposeBag)
        
        selectedItem = itemSelected
            .withLatestFrom(cellData) { idx, list in
                list[idx]
            }
            .asDriver(onErrorJustReturn: nil)
            
    }
}
