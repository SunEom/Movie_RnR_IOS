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
    let loginRequestResult = PublishSubject<LoginRequestResult>()
    
    init() {
        let loginData = Observable
            .combineLatest(id, password)
        
        loginPressed
            .withLatestFrom(loginData)
            .filter { $0! == "" || $1! == "" }
            .subscribe(onNext: { [weak self] (id, password) in
                guard let self = self else { return }
                if id! == "" {
                    self.loginRequestResult.onNext(LoginRequestResult(isSuccess: false, message: "아이디를 입력해주세요."))
                } else if password! == "" {
                    self.loginRequestResult.onNext(LoginRequestResult(isSuccess: false, message: "비밀번호를 입력해주세요."))
                }
            })
            .disposed(by: disposeBag)
            
        loginPressed
            .withLatestFrom(loginData)
            .filter { $0! != "" && $1! != "" }
            .subscribe(onNext:{ [weak self] (id, password) in
                guard let self = self else { return }
                UserManager.requestPostLogin(id: id ?? "", password: password ?? "" )
                
                //현재 로그인 요청의 실패여부를 확인하지 않고 항상 성공한다는 메세지가 표시됨.
                // 존재하지 않는 아이디 혹은 비밀번호를 입력하거나 네트워크 에러 등으로 로그인이 되지 않았을 때 처리가 되어있지 않음
                self.loginRequestResult.onNext(LoginRequestResult(isSuccess: true, message: nil))
            })
            .disposed(by: disposeBag)
            
            
    }
}

struct LoginRequestResult {
    let isSuccess: Bool
    let message: String?
}
