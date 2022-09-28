//
//  StartViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa


class StartViewModel {
    let disposeBag = DisposeBag()
    
    let loginCheckStart = PublishSubject<Void>()
    
    let loginChecked = BehaviorSubject<Bool>(value: false)
    
    init(repository: UserRepository = UserRepository()) {
        
        UserManager.getInstance()
            .map { $0 != nil}
            .bind(to: loginChecked)
            .disposed(by: disposeBag)
        
        
        if let id = UserDefaults.standard.string(forKey: "id"), let password = UserDefaults.standard.string(forKey: "password") {
//            UserManager.requestPostLogin(id: id, password: password)
            
            repository.postLoginRequest(id: id, password: password)
                .subscribe(onNext:{ [weak self] _ in
                    guard let self = self else { return }
                    self.loginChecked.onNext(true)
                })
                .disposed(by: disposeBag)
                
        }
        else {
            loginChecked.onNext(true)
        }
        
    }
}
