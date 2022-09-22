//
//  DangerZoneViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct DangerZoneViewModel {
    
    let disposeBag = DisposeBag()
    
    let buttonSelected = PublishSubject<Void>()
    let confirmSelected = PublishSubject<Void>()
    
    let accountRemoveRequestResult = PublishSubject<AccountRemoveRequestResult>()
    
    init() {
        
        confirmSelected
            .flatMapLatest { ProfileNetwork().deleteAccount() }
            .map { result in
                switch result {
                    case .success(_):
                        return AccountRemoveRequestResult(isSuccess: true, message: nil)
                    case .failure(let error):
                        return AccountRemoveRequestResult(isSuccess: false, message: error.rawValue)
                }
            }
            .bind(to: accountRemoveRequestResult)
            .disposed(by: disposeBag)
        
    }
    
}

struct AccountRemoveRequestResult {
    let isSuccess: Bool
    let message: String?
}
