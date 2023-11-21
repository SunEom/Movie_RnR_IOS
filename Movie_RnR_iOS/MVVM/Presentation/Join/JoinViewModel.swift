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
    
    private let disposeBag = DisposeBag()
    private let repository: ProfileRepository
    
    struct Input {
        let idCheckTrigger: Driver<Void>
        let nickCheckTrigger: Driver<Void>
        let joinTrigger: Driver<Void>
        let id: Driver<String>
        let password: Driver<String>
        let passwordCheck: Driver<String>
        let nickname: Driver<String>
        let genderIdx: Driver<Int>
    }
    
    struct Output {
        let idCheckResult: Driver<RequestResult>
        let nickCheckResult: Driver<RequestResult>
        let joinResult: Driver<RequestResult>
        let genderList: Driver<[String]>
        let saveAvailable: Driver<Bool>
    }
    
    init(_ repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func transfrom(input: Input) -> Output {
        let idCheck = BehaviorSubject(value: false)
        let idCheckResult = input.idCheckTrigger
            .withLatestFrom(input.id)
            .flatMapLatest { repository.checkId(id: $0).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
            .do(onNext: {
                if $0.isSuccess {
                    idCheck.onNext(true)
                }
            })
        input.id.distinctUntilChanged().map { _ in false }.asObservable().bind(to: idCheck).disposed(by: disposeBag)
        
        let nickCheck = BehaviorSubject(value: false)
        let nickCheckResult = input.nickCheckTrigger
            .withLatestFrom(input.nickname)
            .flatMapLatest { repository.nicknameCheck(nickname: $0).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
            .do(onNext: {
                if $0.isSuccess {
                    nickCheck.onNext(true)
                }
            })
        input.nickname.distinctUntilChanged().map { _ in false }.asObservable().bind(to: nickCheck).disposed(by: disposeBag)
        
        let saveAvailable = Driver.combineLatest(idCheck.asDriver(onErrorJustReturn: false), nickCheck.asDriver(onErrorJustReturn: false))
            .map { $0 && $1 }
        
        let genderList = Driver.just(["None","Man","Woman"])
        let gender = BehaviorSubject(value: "None")
        input.genderIdx.withLatestFrom(genderList) { row, list in list[row] }.asObservable().bind(to: gender).disposed(by: disposeBag)
        
        let joinResult = input.joinTrigger.withLatestFrom(Driver.combineLatest(input.id, input.password, input.passwordCheck, input.nickname, gender.asDriver(onErrorJustReturn: "None")))
            .flatMapLatest { repository.join(id: $0, password: $1, passwordCheck: $2, nickname: $3, gender: $4).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))}
        
        return Output(idCheckResult: idCheckResult, nickCheckResult: nickCheckResult, joinResult: joinResult, genderList: genderList, saveAvailable: saveAvailable)
    }
}
