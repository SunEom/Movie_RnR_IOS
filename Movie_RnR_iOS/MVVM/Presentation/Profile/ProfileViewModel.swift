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
    
    let menuList = Observable<[String]>.just(["Edit Profile", "Change Password", "View Postings", "Danger Zone"]).asDriver(onErrorJustReturn: [])
}
