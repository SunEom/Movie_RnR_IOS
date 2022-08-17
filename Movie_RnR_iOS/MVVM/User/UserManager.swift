//
//  User.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/13.
//

import Foundation
import RxSwift
import RxCocoa

class UserManager {
    static let disposeBag = DisposeBag()
    
    private static var user: Login?
    static let isLoggedIn = PublishSubject<Bool>()
    
    private init() {
        UserManager.user = nil
    }
    
    static func getInstance() -> Login? {
        return UserManager.user
    }
    
    static func requestPostLogin(id: String, password: String) {
        LoginNetwork().requestPostLogin(id: id, password: password)
            .subscribe(onSuccess: { result in
                guard case .success(let response) = result else { return isLoggedIn.onNext(false) }
                self.user = response.data
                isLoggedIn.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}
