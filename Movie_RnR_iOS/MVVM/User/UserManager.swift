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
    
    
    static func login(userData: Login?) {
        self.user.onNext(userData)
    }
    
    static func logout() {
        self.user.onNext(nil)
        
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    static func update(with profile: Profile) {
        ProfileNetwork().updateProfile(with: profile)
            .map { result -> [Profile] in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .subscribe(onSuccess: { _ in
                _ = UserRepository().getLoginRequest()
            })
            .disposed(by: disposeBag)
            
    }
}
