//
//  User.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/13.
//

import Foundation
import RxSwift

class User {
    static let disposeBag = DisposeBag()
    
    private static var user: Login?
    
    private init() {
        User.user = nil
    }
    
    static func getInstance() -> Login? {
        return User.user
    }
    
    static func requestPostLogin(id: String, password: String) {
        LoginNetwork().requestPostLogin(id: id, password: password)
            .map { result -> Login? in
                guard case .success(let response) = result else { return nil }
                return response.data
            }
            .asObservable()
            .subscribe { userData in
                self.user = userData
            }
            .disposed(by: disposeBag)
    }
}
