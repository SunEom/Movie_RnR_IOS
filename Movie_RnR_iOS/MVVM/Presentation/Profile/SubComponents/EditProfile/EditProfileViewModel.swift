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
        
        Observable
            .combineLatest(UserManager.getInstance(), nickname, gender, biography, facebook, instagram, twitter)
            .map {
                 Profile(id: $0.0!.id , nickname: $0.1, gender: $0.2, biography: $0.3, facebook: $0.4, instagram: $0.5, twitter: $0.6)
            }
            .bind(to: editData)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(editData)
            .subscribe(onNext: {
                UserManager.update(with: $0)
            })
            .disposed(by: disposeBag)
        
        let nickCheckResult = nicknameButtonTap
            .withLatestFrom(nickname)
            .flatMapLatest(ProfileNetwork().requestNicknameCheck)
        
        nickCheckResult
            .map { result -> (title: String, message: String) in
                guard case .success(let response) = result else { return ("Error", "Please try later") }
                if response.already {
                    return ("Not Available", "This nickname is already used")
                } else {
                    return ("Available", "This nickname can be used")
                }
            }
            .bind(to: nickAlert)
            .disposed(by: disposeBag)
        
        nickCheckResult
            .map { result -> Bool in
                guard case .success(let response) = result else { return false }
                if response.already {
                    return false
                } else {
                    return true
                }
            }
            .bind(to: nickCheck)
            .disposed(by: disposeBag)
            
    }
}
