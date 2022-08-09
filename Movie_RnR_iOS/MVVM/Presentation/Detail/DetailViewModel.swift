//
//  DetailViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct DetailViewModel {
    let post: Post!
    
    let cellData: Driver<[String]>
    
    init(_ post: Post) {
        
        self.post = post
        
        cellData = Observable.just(["image","title","topStackView","overview","bottomStackview","comments"])
            .asDriver(onErrorJustReturn: [])
        
    }
}
