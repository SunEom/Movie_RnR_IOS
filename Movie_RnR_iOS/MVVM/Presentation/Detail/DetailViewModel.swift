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
    
    let titleCellViewModel = TitleCellViewModel()
    let topStackViewCellViewModel = TopStackViewCellViewModel()
    let overviewCellViewModel = OverviewCellViewModel()
    let bottomStackViewCellViewModel = BottomStackViewCellViewModel()
    
    let post: Post!
    
    let cellList: Driver<[String]>
    
    let detailData = PublishSubject<PostDetail?>()
    
    let refresh = PublishSubject<Void>()
    
    init(_ post: Post, _ repository: DetailRepository = DetailRepository()) {
        
        self.post = post
        
        cellList = Observable.just(["image","title","topStackView","overview","bottomStackview","comments"])
            .asDriver(onErrorJustReturn: [])
        
        refresh
            .flatMapLatest { repository.fetchPostDetail(post: post) }
            .asObservable()
            .bind(to: detailData)
            .disposed(by: disposeBag)
        
        let postDetail = detailData
            
        postDetail.compactMap { $0?.movie.title }
            .bind(to: titleCellViewModel.title)
            .disposed(by: disposeBag)
        
        postDetail.compactMap { $0?.movie.genres }
            .bind(to: topStackViewCellViewModel.genres)
            .disposed(by: disposeBag)
        
        postDetail.compactMap { "\($0?.movie.rates ?? 0)" }
            .bind(to: topStackViewCellViewModel.rates)
            .disposed(by: disposeBag)
        
        postDetail.compactMap { $0?.movie.overview }
            .bind(to: overviewCellViewModel.overview)
            .disposed(by: disposeBag)

        postDetail.compactMap { $0?.movie.created }
            .bind(to: bottomStackViewCellViewModel.date)
            .disposed(by: disposeBag)
        
        postDetail.compactMap { $0?.user.nickname }
            .bind(to: bottomStackViewCellViewModel.nickname)
            .disposed(by: disposeBag)
        
    }
}
