//
//  UserRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/27.
//

import Foundation
import RxSwift

struct UserRepository {
    func postLoginRequest(id: String, password: String) -> Observable<RequestResult> {
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
