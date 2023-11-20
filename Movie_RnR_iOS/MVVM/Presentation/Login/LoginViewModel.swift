//
//  LoginViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import RxSwift
import RxCocoa

struct LoginViewModel {
    private let disposeBag = DisposeBag()
    private let repository: UserRepository
    
    struct Input {
        let id: Driver<String>
        let pwd: Driver<String>
        let loginTrigger: Driver<Void>
    }
    
    struct Output {
        let loginResult: Driver<RequestResult>
    }
    
    init(_ repository: UserRepository = UserRepository()) {
        self.repository = repository
    }
    
    func transfrom(input: Input) -> Output {
        let loginResult = input.loginTrigger.withLatestFrom(Driver.combineLatest(input.id, input.pwd))
            .flatMapLatest {(id, pwd) in repository.postLoginRequest(id: id, password: pwd).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
        
        return Output(loginResult: loginResult)
    }
}
