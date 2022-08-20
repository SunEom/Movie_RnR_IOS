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
    
    private static var user = BehaviorSubject<Login?>(value: nil)
    
    private init() {
        
    }
    
    static func getInstance() -> BehaviorSubject<Login?> {
        return UserManager.user
    }
    
    static func requestPostLogin(id: String, password: String) {
        LoginNetwork().requestPostLogin(id: id, password: password)
            .subscribe(onSuccess: { result in
                guard case .success(let response) = result else { return }
                user.onNext(response.data)
            })
            .disposed(by: disposeBag)
    }
}
