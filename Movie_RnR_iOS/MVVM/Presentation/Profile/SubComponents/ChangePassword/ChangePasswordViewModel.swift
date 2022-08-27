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
            .filter { (current, new , check) in
                current == "" || new == "" || check == "" || new != check || (current == new && new == check)
            }
            .map { (current, new , check) -> (String, String) in
                if current == "" {
                    return ("실패", "현재 비밀번호를 입력해주세요")
                } else if new == "" {
                    return ("실패", "새로운 비밀번호를 입력해주세요")
                } else if check == "" {
                    return ("실패", "새로운 비밀번호를 다시 입력해주세요")
                } else if new != check {
                    return ("실패", "새로운 비밀번호가 같지 않습니다.")
                } else if current == new && new == check {
                    return ("실패", "현재 비밀번호와 다른 비밀번호를 입력해주세요.")
                } else {
                    return ("실패", "처리 중에 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { (current, new , check) in
                !(current == "" || new == "" || check == "" || new != check || (current == new && new == check))
            }
            .map { return ProfileNetwork().updatePassword(password: $0.0, newPassword: $0.1) }
            .map { result -> (String, String) in
//                guard case .success(let response) = result else { return ("싪패", "비밀번호 변경에 실패하였습니다.") }
//                return ("성공", "비밀번호가 정상적으로 변경되었습니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
    }
}
