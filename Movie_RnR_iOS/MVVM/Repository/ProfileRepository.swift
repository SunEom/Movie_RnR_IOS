//
//  ProfileRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 11/21/23.
//

import Foundation
import RxSwift

struct ProfileRepository {
    func getProfile(userId: Int) -> Observable<Profile?> {
        return ProfileNetwork().fetchProfile(userID: userId)
            .map { result in
                switch result {
                    case .success(let response):
                        return response.data.first
                    case .failure:
                        return nil
                }
            }.asObservable()
    }
    
    func nicknameCheck(nickname: String) -> Observable<RequestResult> {
        return ProfileNetwork().requestNicknameCheck(nickname: nickname)
            .map { result in
                guard case .success(let response) = result else { return RequestResult(isSuccess: false, message: "잠시 후에 다시 시도해주세요.") }
                if response.already {
                    return RequestResult(isSuccess: false, message: "이미 사용중인 닉네임입니다.")
                } else {
                    return RequestResult(isSuccess: true, message: "사용 가능한 닉네임입니다.")
                }
            }
            .asObservable()
    }
    
    func updateProfile(profile: Profile) -> Observable<RequestResult> {
        return ProfileNetwork().updateProfile(with: profile)
            .map { result in
                guard case .success(let response) = result else { return RequestResult(isSuccess: false, message: "잠시 후 다시 시도해주세요.") }
                UserManager.update(with: response.data[0])
                return RequestResult(isSuccess: true, message: "정상적으로 업데이트 되었습니다.")
            }
            .asObservable()
    }
}
