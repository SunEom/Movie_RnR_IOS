//
//  ProfileRepository.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 11/21/23.
//

import Foundation
import RxSwift

struct ProfileRepository {
    
    func join(id: String, password: String, passwordCheck: String, nickname: String, gender: String) -> Observable<RequestResult> {
        if id == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "아이디를 입력해주세요."))
        } else if password == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "비밀번호를 입력해주세요."))
        } else if passwordCheck == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "비밀번호 확인란을 입력해주세요."))
        } else if nickname == ""  {
            return Observable.just(RequestResult(isSuccess: false, message: "닉네임을 입력해주세요."))
        } else if password != passwordCheck {
            return Observable.just(RequestResult(isSuccess: false, message: "비밀번호가 서로 같지 않습니다."))
        }
        
        return ProfileNetwork().requestJoin(with: (id, password, nickname, gender))
            .map { result in
                guard case .success(let response) = result else { return RequestResult(isSuccess: false, message: "잠시 후에 다시 시도해주세요.") }
                if (200..<300).contains(response.code)  {
                    return RequestResult(isSuccess: true, message: "회원가입에 성공했습니다.")
                } else {
                    return RequestResult(isSuccess: false, message: "회원 가입에 실패했습니다.")
                }
            }
            .asObservable()
    }
    func checkId(id: String) -> Observable<RequestResult> {
        return ProfileNetwork().requestIdCheck(id: id)
            .map { result in
                guard case .success(let response) = result else { return RequestResult(isSuccess: false, message: "잠시 후에 다시 시도해주세요.") }
                if response.already {
                    return RequestResult(isSuccess: false, message: "이미 사용중인 아이디입니다.")
                } else {
                    return RequestResult(isSuccess: true, message: "사용 가능한 아이디입니다.")
                }
            }
            .asObservable()
    }
    
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
    
    func updatePassword(current: String, new: String, check: String) -> Observable<RequestResult> {
        
        if current == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "현재 비밀번호를 입력해주세요."))
        } else if new == "" {
            return Observable.just(RequestResult(isSuccess: false, message: "새로운 비밀번호를 입력해주세요."))
        } else if check == ""  {
            return Observable.just(RequestResult(isSuccess: false, message: "새로운 비밀번호를 다시 입력해주세요."))
        } else if new != check {
            return Observable.just(RequestResult(isSuccess: false, message: "비밀번호가 서로 같지 않습니다."))
        }
        
        return ProfileNetwork().updatePassword(password: current, newPassword: new)
            .map { result in
                guard case .success(_) = result else { return RequestResult(isSuccess: false, message: "잠시 후에 다시 시도해주세요.")}
                
                return RequestResult(isSuccess: true, message: "비밀번호가 정상적으로 변경 되었습니다.")
            }
            .asObservable()
    }
    
    func deleteAccount() -> Observable<RequestResult> {
        return ProfileNetwork().deleteAccount()
            .map { result in
                switch result {
                    case .success(_):
                        return RequestResult(isSuccess: true, message: nil)
                    case .failure(let error):
                        return RequestResult(isSuccess: false, message: error.rawValue)
                }
            }
            .asObservable()
    }
}
