//
//  JoinManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/24.
//

import Foundation
import Alamofire

class JoinManager {
    
    var isIdChecked = false
    var isNicknameChecked = false
    var isPasswordChecked = false
    
    func setIsIdChecked(with: Bool) {
        self.isIdChecked = with
    }
    
    func setIsNicknameChecked(with: Bool) {
        self.isNicknameChecked = with
    }
    
    func passwordCheck(for pwd: String, with pwd2: String, completion: (()->Void)? = nil, failure: (()->Void)? = nil ) {
        if pwd == pwd2 {
            isPasswordChecked = true
            completion?()
        } else {
            failure?()
        }
    }
    
    func requestIdCheck (_ id: String, completion: (()->Void)? = nil, failure: (()->Void)? = nil) {
        AF.request("\(Constant.serverURL)/join/id", method: .post, parameters: ["id": id])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CheckResponse.self) { response in
                if let responseData = response.value {
                    if !responseData.already {
                        self.isIdChecked = true
                        completion?()
                    } else {
                        failure?()
                    }
                }
            }
    }
    
    func requestNicknameCheck (_ nickname: String, completion: (()->Void)? = nil, failure: (()->Void)? = nil) {
        AF.request("\(Constant.serverURL)/join/nick", method: .post, parameters: ["nickname": nickname])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CheckResponse.self) { response in
                if let responseData = response.value {
                    if !responseData.already {
                        self.isNicknameChecked = true
                        completion?()
                    } else {
                        failure?()
                    }
                }
            }
    }
    
    func requestJoin(id: String, password: String, nickname: String, gender: String, completion: (()->Void)? = nil) {
        AF.request("\(Constant.serverURL)/join", method: .post, parameters: ["id": id, "password": password, "nickname": nickname, "gender": gender])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: JoinResponse.self) { response in
                UserManager.loginPost(id: id, password: password, completion: completion)
            }
    }
}
