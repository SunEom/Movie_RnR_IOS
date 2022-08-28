//
//  ChangePasswordViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation
import RxSwift
import RxCocoa

struct ChangePasswordViewModel {
    let disposeBag = DisposeBag()
    
    let currentPassword = PublishSubject<String>()
    let newPassword = PublishSubject<String>()
    let newPasswordCheck = PublishSubject<String>()
    
    let saveButtonTap = PublishSubject<Void>()
    
    let alert = PublishSubject<(title: String, messsage: String)>()
    
    init() {
        let inputData = Observable
            .combineLatest(currentPassword, newPassword, newPasswordCheck)
        
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { (current, new, check) in
                return current == "" || new == "" || check == "" || new != check
            }
            .map { (current, new, check) -> (String, String) in
                if current == "" {
                    return ("실패", "현재 비밀번호를 입력해주세요.")
                } else if new == "" {
                    return ("실패", "새로운 비밀번호를 입력해주세요.")
                } else if check == ""  {
                    return ("실패", "새로운 비밀번호를 다시 입력해주세요.")
                } else if new != check {
                    return ("실패", "비밀번호가 서로 같지 않습니다.")
                } else {
                    return ("실패", "처리중에 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
         
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { (current, new, check) in
                return !(current == "" || new == "" || check == "" || new != check)
            }
            .flatMapLatest { (current, new, check) in
                return ProfileNetwork().updatePassword(password: current, newPassword: new)
            }
            .asObservable()
            .map { result -> (String, String) in
                print(result)
                guard case .success(let response) = result else { return ("실패", "잠시후에 다시 시도해주세요.")}
                
                return ("성공", "정상적으로 비밀번호가 변경되었습니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
            
    }
}
