//
//  ProfileViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    let disposeBag = DisposeBag()

    let refresh = PublishSubject<Void>()
    let menuList = Driver<[String]>.just(["Edit Profile", "Change Password", "View Postings", "Danger Zone"])
    
    let userID = PublishSubject<Int>()
    let profile = PublishSubject<[Profile?]>()
    
    let profileFetchResult = PublishSubject<RequestResult>()
    
    let logoutBtnTap = PublishSubject<Void>()
    let logoutRequestResult = PublishSubject<RequestResult>()
    
    init() {
    
        refresh
            .withLatestFrom(userID)
            .flatMapLatest(ProfileNetwork().fetchProfile)
            .subscribe(onNext: { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                    case .success(let response):
                        self.profile.onNext(response.data)
                        
                    case .failure(let error):
                        self.profile.onNext([])
                        self.profileFetchResult.onNext(RequestResult(isSuccess: false, message: error.rawValue))
                        
                }
            })
            .disposed(by: disposeBag)
        
        logoutBtnTap
            .map { UserManager.logout() }
            .map { RequestResult(isSuccess: true, message: nil) }
            .bind(to: logoutRequestResult)
            .disposed(by: disposeBag)
        
    }
}
