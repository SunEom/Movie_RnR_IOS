//
//  JoinViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import Foundation
import RxCocoa
import RxSwift

class JoinViewModel {
    
    let disposeBag = DisposeBag()

    let alert = PublishSubject<(title: String, message: String)>()
    let joinRequestResult = PublishSubject<JoinRequestResult>()
    let idCheckRequestResult = PublishSubject<JoinRequestResult>()
    let nickCheckRequestResult = PublishSubject<JoinRequestResult>()
    
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
        //MARK: - input data management
        
        genderIdx
            .withLatestFrom(genderList) { $1[$0] }
            .bind(to: gender)
            .disposed(by: disposeBag)
        
        let inputData = Observable
            .combineLatest(id, password, nickname, gender)
            
        let inputCheck = Observable.combineLatest(id, password, passwordCheck, nickname, gender)
            .map { ($0.0 != "", $0.1 != "", $0.2 != "", $0.1 == $0.2, $0.3 != "", $0.4 != "") }

        
     //MARK: - ID Check
        
        id.distinctUntilChanged()
            .map { _ in
                false
            }
            .bind(to: idCheck)
            .disposed(by: disposeBag)
        
        idButtonTap
            .withLatestFrom(inputCheck)
            .filter { !$0.0 }
            .map { _ in
                return JoinRequestResult(isSuccess: false, message: "사용하실 아이디를 입력해주세요.")
            }
            .bind(to: joinRequestResult)
            .disposed(by: disposeBag)
        
        
        idButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.0 }
            .withLatestFrom(id)
            .flatMapLatest(ProfileNetwork().requestIdCheck)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let response):
                        if response.already {
                            self.idCheckRequestResult.onNext(JoinRequestResult(isSuccess: false, message: "이미 사용중인 아이디입니다."))
                        } else {
                            self.idCheckRequestResult.onNext(JoinRequestResult(isSuccess: true, message: "사용 가능한 아이디입니다."))
                            self.idCheck.onNext(true)
                        }
                    case .failure(let error):
                        self.idCheckRequestResult.onNext(JoinRequestResult(isSuccess: false, message: error.rawValue))
                }
            })
            
            .disposed(by: disposeBag)
        
        //MARK: - Nickname Check
        
        nickname.distinctUntilChanged()
            .map { _ in
                false
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        nickButtonTap
            .withLatestFrom(inputCheck)
            .filter { !$0.3 }
            .map { _ in
                return JoinRequestResult(isSuccess: false, message: "사용하실 닉네임을 입력해주세요.")
            }
            .bind(to: joinRequestResult)
            .disposed(by: disposeBag)
        
        nickButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.3 }
            .withLatestFrom(nickname)
            .flatMapLatest(ProfileNetwork().requestNicknameCheck)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    case .success(let response):
                        if response.already {
                            self.nickCheckRequestResult.onNext(JoinRequestResult(isSuccess: false, message: "이미 사용중인 닉네임입니다."))
                        } else {
                            self.nickCheckRequestResult.onNext(JoinRequestResult(isSuccess: true, message: "사용 가능한 닉네임입니다."))
                            self.nickCheck.onNext(true)
                        }
                    case .failure(let error):
                        self.nickCheckRequestResult.onNext(JoinRequestResult(isSuccess: false, message: error.rawValue))
                }
            })
            .disposed(by: disposeBag)
        
        //MARK: - Join process
        
        saveButtonTap
            .withLatestFrom(inputCheck)
            .filter { $0.0 && $0.1 && $0.2 && $0.3 && $0.4 && $0.5 }
            .withLatestFrom(idCheck)
            .filter { $0 }
            .withLatestFrom(nickCheck)
            .filter { $0 }
            .withLatestFrom(inputData)
            .flatMapLatest(JoinNetwork().requestJoin)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(_):
                        self.joinRequestResult.onNext(JoinRequestResult(isSuccess: true, message: nil))
                        
                    case .failure(let error):
                        self.joinRequestResult.onNext(JoinRequestResult(isSuccess: false, message: error.rawValue))
                }
            })
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputCheck)
            .filter { !($0.0 && $0.1 && $0.2 && $0.3 && $0.4 && $0.5) }
            .map { (id, pwd, pwdCheck, pwdSame, nick, gender) -> JoinRequestResult in
                if !id {
                    return JoinRequestResult(isSuccess: false, message: "아이디를 입력해주세요.")
                } else if !pwd {
                    return JoinRequestResult(isSuccess: false, message: "비밀번호를 입력해주세요.")
                } else if !pwdCheck {
                    return JoinRequestResult(isSuccess: false, message: "비밀번호를 다시 입력해주세요.")
                } else if !pwdSame {
                    return JoinRequestResult(isSuccess: false, message: "비밀번호가 같지 않습니다.")
                } else if !nick {
                    return JoinRequestResult(isSuccess: false, message: "닉네임을 입력해주세요.")
                } else if !gender {
                    return JoinRequestResult(isSuccess: false, message: "성별을 선택해주세요.")
                } else {
                    return JoinRequestResult(isSuccess: false, message: "처리 도중 오류가 발생하였습니다.")
                }
            }
            .bind(to: joinRequestResult)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(Observable.combineLatest(idCheck, nickCheck))
            .filter { !$0.0 || !$0.1 }
            .map { (id, nick) in
                if !id {
                    return JoinRequestResult(isSuccess: false, message: "아이디 중복확인을 해주세요.")
                } else if !nick {
                    return JoinRequestResult(isSuccess: false, message: "닉네임 중복확인을 해주세요.")
                } else {
                    return JoinRequestResult(isSuccess: false, message: "처리 과정에서 오류가 발생하였습니다.")
                }
            }
            .bind(to: joinRequestResult)
            .disposed(by: disposeBag)
            
    }
    
}

struct JoinRequestResult {
    let isSuccess: Bool
    let message: String?
}
