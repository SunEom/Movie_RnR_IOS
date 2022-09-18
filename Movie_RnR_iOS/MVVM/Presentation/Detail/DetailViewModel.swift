//
//  DetailViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift
import RxCocoa

struct DetailViewModel {
    let disposeBag = DisposeBag()
    
    let post: Post!
    
    let cellList =  Driver<[String]>.just(["image","title","topStackView","overview","bottomStackview","comments"])
        .asDriver(onErrorJustReturn: [])
    
    let detailData = PublishSubject<PostDetail?>()
    
    let refresh = PublishSubject<Void>()
    
    init(_ post: Post, _ repository: DetailRepository = DetailRepository()) {
        
        self.post = post
        
        refresh
            .flatMapLatest { repository.fetchPostDetail(post: post) }
            .asObservable()
            .bind(to: detailData)
            .disposed(by: disposeBag)

        
    }
}
