//
//  DangerZoneViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct DangerZoneViewModel {
    private let disposeBag = DisposeBag()
    private let repository: ProfileRepository
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let result: Driver<RequestResult>
    }
    
    init(_ repoistory: ProfileRepository = ProfileRepository()) {
        self.repository = repoistory
    }
    
    func transform(input: Input) -> Output {
        let result = input.trigger
            .flatMapLatest { repository.deleteAccount().asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
        
        return Output(result: result)
    }
    
}
