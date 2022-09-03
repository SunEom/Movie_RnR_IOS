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
    
    let alert = PublishSubject<(String, String)>()
    
    init() {
        confirmSelected
            .flatMapLatest { ProfileNetwork().deleteAccount() }
            .map { result -> (String, String) in
                guard case .success(_) = result else { return ("실패", "잠시후 다시 시도해주세요.")}
                return ("성공", "그 동안 이용해주셔서 감사합니다.")
            }
            .bind(to: alert)
            .disposed(by: diseposetBag)
    }
    
}
