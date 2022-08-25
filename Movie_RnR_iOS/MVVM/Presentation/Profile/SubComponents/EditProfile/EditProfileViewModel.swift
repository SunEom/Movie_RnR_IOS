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
    
    let nickAlert = PublishSubject<(title: String, message: String)>()
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
            .bind(to: nickAlert)
            .disposed(by: disposeBag)
        
        nickCheckResult
            .map { result -> Bool in
                guard case .success(let response) = result else { return false }
                print("response", response.already)
                return !response.already
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        nickname
            .distinctUntilChanged()
            .map { _ in
                return false
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
        
        // save button process
        
        Observable
            .combineLatest(UserManager.getInstance(), nickname, gender, biography, facebook, instagram, twitter)
            .map {
                Profile(id: $0.0!.id , nickname: $0.1, gender: $0.2, biography: $0.3, facebook: $0.4, instagram: $0.5, twitter: $0.6)
            }
            .bind(to: editData)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(nickCheck)
            .withLatestFrom(editData) { isChecked, data in
                (isChecked, data)
            }
            .subscribe(onNext: { (isChecked, data) in
                if isChecked {
                    UserManager.update(with: data)
                }
            })
            .disposed(by: disposeBag)
        
        
        saveButtonTap
            .withLatestFrom(nickCheck)
            .filter { !$0 }
            .map {
                print("nick", $0)
                return ("실패", "닉네임 확인 버튼을 눌러주세요")
            }
            .bind(to: nickAlert)
            .disposed(by: disposeBag)
    }
}
