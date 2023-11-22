//
//  UserRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/27.
//

import Foundation
import RxSwift

struct UserRepository {
    func autoLoginRequest() -> Observable<RequestResult> {
        if let id = UserDefaults.standard.string(forKey: "id"), let password = UserDefaults.standard.string(forKey: "password") {
            return postLoginRequest(id: id, password: password)
        } else {
            return Observable.just(RequestResult(isSuccess: false, message: nil))
        }
    }
    
    func postLoginRequest(id: String, password: String) -> Observable<RequestResult> {
        if id == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "아이디를 입력해주세요."))
        }
        
        if password == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "비밀번호를 입력해주세요."))
        }
        
         return LoginNetwork().requestPostLogin(id: id, password: password)
            .map { result in
                switch result {
                    case .success(let response):
                        if response.code == 200 {
                            UserManager.login(userData: response.data)
                            UserDefaults.standard.setValue(id, forKey: "id")
                            UserDefaults.standard.setValue(password, forKey: "password")
                            return RequestResult(isSuccess: true, message: nil)
                        } else {
                            return RequestResult(isSuccess: false, message: response.error)
                        }
                        
                    case .failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                        
                }
            }
            .asObservable()
    }
    
    func getLoginRequest() -> Observable<RequestResult> {
        LoginNetwork().requestGetLogin()
            .map { result in
                switch result {
                    case .success(let response):
                        if response.code == 200 {
                            UserManager.login(userData: response.data)
                            return RequestResult(isSuccess: true, message: nil)
                        } else {
                            return RequestResult(isSuccess: false, message: response.error)
                        }
                        
                    case .failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                        
                }
            }
            .asObservable()
    }
}
