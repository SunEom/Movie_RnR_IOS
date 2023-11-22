//
//  EditProfileViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import RxSwift
import RxCocoa

struct EditProfileViewModel {
    private let disposeBag = DisposeBag()
    private let repository: ProfileRepository
    
    struct Input {
        let nickCheckTrigger: Driver<Void>
        let nickname: Driver<String>
        let genderIdx: Driver<Int>
        let biography: Driver<String>
        let facebook: Driver<String>
        let instagram: Driver<String>
        let twiiter: Driver<String>
        let updateTrigger: Driver<Void>
    }
    
    struct Output {
        let genderList: Driver<[String]>
        let nickCheckResult: Driver<RequestResult>
        let updateResult: Driver<RequestResult>
    }
    
    init(_ repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        let genderList = Driver.just(["None","Man","Woman"])
        
        let nickCheck = BehaviorSubject<Bool>(value: true)
        input.nickname.distinctUntilChanged().map { _ in false }.asObservable().bind(to: nickCheck).disposed(by: disposeBag)
        
        let nickCheckResult = input.nickCheckTrigger
            .withLatestFrom(input.nickname)
            .flatMap { repository.nicknameCheck(nickname: $0)
                    .do { result in
                        if result.isSuccess {
                            nickCheck.onNext(true)
                        }
                    }
                    .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))
            }

        
        let gender = input.genderIdx.withLatestFrom(genderList) { row, list in list[row] }
        
        let updateResult = input.updateTrigger
            .withLatestFrom(Driver.combineLatest(UserManager.getInstance().asDriver(onErrorJustReturn: nil), input.nickname, gender, input.biography, input.facebook, input.instagram, input.twiiter))
            .map {(user, nickname, gender, biography, facebook, instagram, twiiter) in
                return Profile(id: user?.id ?? -1, nickname: nickname, gender: gender, biography: biography, facebook: facebook, instagram: instagram, twitter: twiiter)
            }
            .withLatestFrom(nickCheck.asDriver(onErrorJustReturn: false)) { ($0, $1) }
            .flatMapLatest { profile, nickCheck in
                if nickCheck {
                    return repository.updateProfile(profile: profile).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))
                } else {
                    return Driver.just(RequestResult(isSuccess: false, message: "닉네임 중복 확인을 해주세요."))
                }
            }
        
        
        return Output(genderList: genderList, nickCheckResult: nickCheckResult, updateResult: updateResult)
    }
}
