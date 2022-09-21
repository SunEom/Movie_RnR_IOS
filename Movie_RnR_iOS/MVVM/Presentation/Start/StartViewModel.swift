//
//  StartViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa


struct StartViewModel {
    let disposeBag = DisposeBag()
    
    let loginCheckStart = PublishSubject<Void>()
    
    let loginChecked = BehaviorSubject<Bool>(value: false)
    
    init() {
        
        UserManager.getInstance()
            .map { $0 != nil}
            .bind(to: loginChecked)
            .disposed(by: disposeBag)
        
        
        if let id = UserDefaults.standard.string(forKey: "id"), let password = UserDefaults.standard.string(forKey: "password") {
            UserManager.requestPostLogin(id: id, password: password)
        }
        else {
            loginChecked.onNext(true)
        }
        
    }
}
