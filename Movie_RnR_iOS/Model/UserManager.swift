//
//  UserManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import Foundation
import Alamofire

class UserManager {
    private static var user: UserData?
    
    
    private init() {
        UserManager.user = nil
    }
    
    static func getInstance() -> UserData? {
        return UserManager.user
    }
    
    static func loginPost(id: String, password: String, completion: (() -> Void)? = nil) {
        AF.request("\(Constant.serverURL)/auth/login", method: .post, parameters: ["id": id, "password": password])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
                
                if let err = response.value?.error {
                    print("Post Login Error : \(err)")
                    return
                } else if let userData = response.value?.data {
                    print("Post Login: \(userData)")
                    
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")
                    
                    UserManager.user = userData
                    if let completion = completion {
                        completion()
                    }
                }
            }
    }
    
    static func loginGet(completion: (() -> Void)? = nil) {
        AF.request("\(Constant.serverURL)/auth/login", method: .get)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: LoginResponse.self) { response in
                
                if let err = response.value?.error {
                    print("Get Login Error: \(err)")
                    return
                } else if let userData = response.value?.data {
                    print("Get Login : \(userData)")
                }
                
            }
            
    }
    
    static func logout(completion: (()->Void)? = nil) {
        AF.request("\(Constant.serverURL)/auth/logout", method: .get)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    self.user = nil
                    
                    UserDefaults.standard.removeObject(forKey: "id")
                    UserDefaults.standard.removeObject(forKey: "password")
                    
                    completion?()
                    
                case .failure(let error):
                    print("Logout Error: \(error)")
                    return
                    
                default:
                    return
                }
            }
    }
    
}

