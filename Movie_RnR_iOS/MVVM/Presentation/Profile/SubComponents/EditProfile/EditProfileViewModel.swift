//
//  EditProfileViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import RxSwift
import RxCocoa

struct EditProfileViewModel {
    let disposeBag = DisposeBag()
    
    let genderList = Driver.just(["None","Man","Woman"])
    
    let alert = PublishSubject<(title: String, message: String)>()
    let nickCheck = BehaviorSubject<Bool>(value: true)
    let nickname = PublishSubject<String>()
    let genderIdx = PublishSubject<Int>()
    let gender = PublishSubject<String>()
    let biography = PublishSubject<String>()
    let facebook = PublishSubject<String>()
    let instagram = PublishSubject<String>()
    let twitter = PublishSubject<String>()
    
    let editData = PublishSubject<Profile>()
    
    let saveButtonTap = PublishSubject<Void>()
    let nicknameButtonTap = PublishSubject<Void>()
    
    init() {
        
        // gender setting
        genderIdx
            .withLatestFrom(genderList) { $1[$0] }
            .bind(to: gender)
            .disposed(by: disposeBag)
        
        // nickname process
        
        let nickCheckResult = nicknameButtonTap
            .withLatestFrom(nickname)
            .flatMapLatest(ProfileNetwork().requestNicknameCheck)
        
        nickCheckResult
            .map { result -> (title: String, message: String) in
                guard case .success(let response) = result else { return ("오류", "잠시후에 다시 시도해주세요") }
                if response.already {
                    return ("실패", "이미 사용중인 닉네임입니다.")
                } else {
                    return ("성공", "사용 가능한 닉네임입니다.")
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
        
        nickname
            .distinctUntilChanged()
            .withLatestFrom(UserManager.getInstance()) {
                ($0, $1)
            }
            .filter { $0 != $1?.nickname }
            .map { _ in
                return false
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        // save button process
        
        let inputData = Observable
            .combineLatest(UserManager.getInstance(), nickname, gender, biography, facebook, instagram, twitter)
        
        inputData
            .map {
                Profile(id: $0.0?.id ?? -1 , nickname: $0.1, gender: $0.2, biography: $0.3, facebook: $0.4, instagram: $0.5, twitter: $0.6)
            }
            .bind(to: editData)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { !($0.1 == "" || $0.2 == "" || $0.4 == "" || $0.5 == "" || $0.6 == "") }
            .withLatestFrom(nickCheck)
            .filter { $0 }
            .withLatestFrom(editData)
            .subscribe(onNext: { data in
                UserManager.update(with: data)
            })
            .disposed(by: disposeBag)
        
        
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { $0.1 == "" || $0.2 == "" || $0.4 == "" || $0.5 == "" || $0.6 == ""}
            .map { data -> (title: String, message: String) in
                if data.1 == "" {
                    return ("알림", "닉네임을 입력해주세요")
                } else if data.2 == "" {
                    return("알림", "성별을 선택해주세요")
                } else if data.4 == "" {
                    return ("알림", "페이스북 주소를 입력해주세요")
                } else if data.5 == "" {
                    return ("알림", "인스타그램 주소를 입력해주세요")
                } else if data.6 == "" {
                    return ("알림", "트위터 주소를 입력해주세요")
                } else {
                    return ("오류", "처리중에 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(nickCheck)
            .filter { !$0 }
            .map { _ in
                return ("실패", "닉네임 확인 버튼을 눌러주세요")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
    }
}
