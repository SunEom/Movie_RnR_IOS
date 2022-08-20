//
//  ProfileViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import Foundation
import RxSwift
import RxCocoa

struct ProfileViewModel {
    let disposeBag = DisposeBag()
    var str = ""
    
    let editProfileViewModel = EditProfileViewModel()
    
    let menuList = Observable<[String]>.just(["Edit Profile", "Change Password", "View Postings", "Danger Zone"]).asDriver(onErrorJustReturn: [])
    
    let userID = PublishSubject<Int>()
    let profile = PublishSubject<[Profile]>()
    
    init() {
        userID
            .flatMapLatest(ProfileNetwork().fetchProfile)
            .map { result -> [Profile] in
                guard case .success(let response) = result else { return [] }
                return response.data
            }
            .bind(to: profile)
            .disposed(by: disposeBag)
    
    }
}
