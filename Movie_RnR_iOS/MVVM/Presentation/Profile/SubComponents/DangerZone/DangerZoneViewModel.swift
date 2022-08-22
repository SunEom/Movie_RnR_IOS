//
//  DangerZoneViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct DangerZoneViewModel {
    
    let diseposetBag = DisposeBag()
    
    let buttonSelected = PublishSubject<Void>()
    let confirmSelected = PublishSubject<Void>()
    
    init() {
        confirmSelected.subscribe(onNext: { _ in
            print("Removed!")
        })
        .disposed(by: diseposetBag)
    }
    
}
