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
    private let disposeBag = DisposeBag()
    private let repository: ProfileRepository
    struct Input {
        let trigger: Driver<Void>
        let current: Driver<String>
        let new: Driver<String>
        let newCheck: Driver<String>
    }
    
    struct Output {
        let result: Driver<RequestResult>
    }
    
    init(_ repository: ProfileRepository = ProfileRepository()) {
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        let result = input.trigger
            .withLatestFrom(Driver.combineLatest(input.current, input.new, input.newCheck))
            .flatMapLatest { repository.updatePassword(current: $0, new: $1, check: $2).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
        
        return Output(result: result)
    }
}
