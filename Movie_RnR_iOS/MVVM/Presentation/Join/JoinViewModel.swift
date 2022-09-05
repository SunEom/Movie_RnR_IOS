//
//  JoinViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import Foundation
import RxCocoa
import RxSwift

struct JoinViewModel {
    
    let disposeBag = DisposeBag()

    let alert = PublishSubject<(title: String, message: String)>()
    
    let genderList = Driver.of(["None","Man","Woman"])
    let genderIdx = BehaviorSubject<Int>(value: 0)
    
    let id = PublishSubject<String>()
    let password = PublishSubject<String>()
    let passwordCheck = PublishSubject<String>()
    let nickname = PublishSubject<String>()
    let gender = BehaviorSubject<String>(value: "None")

    let idButtonTap = PublishSubject<Void>()
    let nickButtonTap = PublishSubject<Void>()
    
    let idCheck = BehaviorSubject<Bool>(value: false)
    let nickCheck = BehaviorSubject<Bool>(value: false)

    let saveButtonTap = PublishSubject<Void>()
    
    init() {
        genderIdx
            .withLatestFrom(genderList) { $1[$0] }
            .bind(to: gender)
            .disposed(by: disposeBag)
        
        let inputData = Observable
            .combineLatest(id, password, nickname, gender)
            
        let inputCheck = Observable.combineLatest(id, password, passwordCheck, nickname, gender)
            .map { ($0.0 != "", $0.1 != "", $0.2 != "", $0.1 == $0.2, $0.3 != "", $0.4 != "") }
        
        id.distinctUntilChanged()
            .map { _ in
                false
            }
            .bind(to: idCheck)
            .disposed(by: disposeBag)
        
        nickname.distinctUntilChanged()
            .map { _ in
                false
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        idButtonTap
            .withLatestFrom(inputCheck)
            .filter { !$0.0 }
            .map { _ in
                return ("실패", "비밀번호를 입력해주세요.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        let idCheckResult = idButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.0 }
            .withLatestFrom(id)
            .flatMapLatest(ProfileNetwork().requestIdCheck)
        
        
        idCheckResult
            .map { result -> (title: String, message: String) in
                guard case .success(let response) = result else { return ("오류", "잠시후에 다시 시도해주세요") }
                if response.already {
                    return ("실패", "이미 사용중인 아이디입니다.")
                } else {
                    return ("확인", "사용 가능한 아이디입니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        idCheckResult
            .map { result -> Bool in
                guard case .success(let response) = result else { return false }
                return !response.already
            }
            .bind(to: idCheck)
            .disposed(by: disposeBag)
        
        nickButtonTap
            .withLatestFrom(inputCheck)
            .filter { !$0.3 }
            .map { _ in
                return ("실패", "닉네임을 입력해주세요.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        
        let nickCheckResult = nickButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.3 }
            .withLatestFrom(nickname)
            .flatMapLatest(ProfileNetwork().requestNicknameCheck)
        
        nickCheckResult
            .map { result -> (title: String, message: String) in
                guard case .success(let response) = result else { return ("오류", "잠시후에 다시 시도해주세요") }
                if response.already {
                    return ("실패", "이미 사용중인 닉네임입니다.")
                } else {
                    return ("확인", "사용 가능한 닉네임입니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        nickCheckResult
            .map { result -> Bool in
                guard case .success(let response) = result else { return false }
                return !response.already
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.0 && $0.1 && $0.2 && $0.3 && $0.4 && $0.5 }
            .withLatestFrom(idCheck)
            .filter { $0 }
            .withLatestFrom(nickCheck)
            .filter { $0 }
            .withLatestFrom(inputData)
            .flatMapLatest(JoinNetwork().requestJoin)
            .map { result -> (String, String) in
                guard case .success(let response) = result else { return ("오류", "잠시후 다시 시도해주세요.") }
                print(response)
                UserManager.getInstance().onNext(response.data)
                return ("성공", "회원가입을 환영합니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputCheck)
            .filter { !($0.0 && $0.1 && $0.2 && $0.3 && $0.4 && $0.5) }
            .map { (id, pwd, pwdCheck, pwdSame, nick, gender) -> (String, String) in
                if !id {
                    return ("실패", "아이디를 입력해주세요.")
                } else if !pwd {
                    return ("실패", "비밀번호를 입력해주세요.")
                } else if !pwdCheck {
                    return ("실패", "비밀번호를 다시 입력해주세요.")
                } else if !pwdSame {
                    return ("실패", "비밀번호가 같지 않습니다.")
                } else if !nick {
                    return ("실패", "닉네임을 입력해주세요.")
                } else if !gender {
                    return ("실패", "성별을 선택해주세요.")
                } else {
                    return ("실패", "처리 도중 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(Observable.combineLatest(idCheck, nickCheck))
            .filter { !$0.0 || !$0.1 }
            .map { (id, nick) in
                if !id {
                    return ("실패", "아이디 중복확인을 해주세요.")
                } else if !nick {
                    return ("실패", "닉네임 중복확인을 해주세요.")
                } else {
                    return ("실패", "처리 과정에서 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputData)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
            
    }
    
}
