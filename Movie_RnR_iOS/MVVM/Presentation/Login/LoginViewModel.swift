//
//  LoginViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    let id = BehaviorSubject<String?>(value: "")
    let password = BehaviorSubject<String?>(value: "")
    let loginPressed = PublishSubject<Void>()
    let loginRequestResult = PublishSubject<RequestResult>()
    
    init(_ repository: UserRepository = UserRepository()) {
        let loginData = Observable
            .combineLatest(id, password)
        
        //MARK: - 로그인 입력 오류
        loginPressed
            .withLatestFrom(loginData)
            .filter { $0! == "" || $1! == "" }
            .subscribe(onNext: { [weak self] (id, password) in
                guard let self = self else { return }
                if id! == "" {
                    self.loginRequestResult.onNext(RequestResult(isSuccess: false, message: "아이디를 입력해주세요."))
                } else if password! == "" {
                    self.loginRequestResult.onNext(RequestResult(isSuccess: false, message: "비밀번호를 입력해주세요."))
                }
            })
            .disposed(by: disposeBag)
        
        
        //MARK: - 로그인 요청
        
        loginPressed
            .withLatestFrom(loginData)
            .filter { $0! != "" && $1! != "" }
            .map { repository.postLoginRequest(id: $0.0!, password: $0.1!) }
            .flatMapLatest{ $0 }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loginRequestResult.onNext(result)
                
            })
            .disposed(by: disposeBag)
        
        
        
    }
}
