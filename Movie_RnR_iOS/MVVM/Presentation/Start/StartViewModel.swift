//
//  StartViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa


struct StartViewModel {
    private let disposeBag = DisposeBag()
    private let repository: UserRepository
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let loginCheckFin: Driver<Void>
    }
    
    
    init(repository: UserRepository = UserRepository()) {
        self.repository = repository
    }
    
    func transfrom (input: Input) -> Output {
        let loginCheckFin = input.trigger.flatMapLatest { repository.autoLoginRequest().map { _ in Void() }.asDriver(onErrorJustReturn: Void()) }
        
        return Output(loginCheckFin: loginCheckFin)
    }
    
}
