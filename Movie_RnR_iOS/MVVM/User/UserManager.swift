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
                UserDefaults.standard.setValue(id, forKey: "id")
                UserDefaults.standard.setValue(password, forKey: "password")
                user.onNext(response.data)
            })
            .disposed(by: disposeBag)
    }
    
    static func requestGetLogin() {
        LoginNetwork().requestGetLogin()
            .subscribe(onSuccess: { result in
                guard case .success(let response) = result else { return }
                user.onNext(response.data)
            })
            .disposed(by: disposeBag)
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
                self.requestGetLogin()
            })
            .disposed(by: disposeBag)
            
    }
}
