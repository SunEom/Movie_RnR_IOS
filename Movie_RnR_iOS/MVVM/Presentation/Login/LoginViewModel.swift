//
//  LoginViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import RxSwift
import RxCocoa

struct LoginViewModel {
    let disposeBag = DisposeBag()
    
    let id = PublishSubject<String?>()
    let password = PublishSubject<String?>()
    let loginPressed = PublishSubject<Void>()
    
    init() {
        let loginData = Observable
            .combineLatest(id, password)
        
        loginPressed
            .withLatestFrom(loginData)
            .subscribe(onNext: {
                User.requestPostLogin(id: $0.0 ?? "", password: $0.1 ?? "")
            })
            .disposed(by: disposeBag)
            
        
        
    }
}
