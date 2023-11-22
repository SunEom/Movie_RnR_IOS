//
//  ProfileViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import Foundation
import RxSwift
import RxCocoa

enum ProfileMenu: String {
    case editProfile = "Edit Profile"
    case changePassword = "Change Password"
    case viewPostings = "View Postings"
    case dangerZone = "Danger Zone"
    case error = "Error"
}

struct ProfileViewModel {
    private let disposeBag = DisposeBag()
    private let repository: ProfileRepository
    private let userID: Int

    struct Input {
        let trigger: Driver<Void>
        let logoutTrigger: Driver<Void>
        let menuSelect: Driver<IndexPath>
    }
    
    struct Output {
        let profile: Driver<Profile?>
        let isMine: Driver<Bool>
        let menuList: Driver<[ProfileMenu]>
        let logoutResult: Driver<RequestResult>
        let selectedMenu: Driver<ProfileMenu>
    }
    
    init(userID: Int,_ repository: ProfileRepository = ProfileRepository() ) {
        self.userID = userID
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        let profile = input.trigger.flatMapLatest { repository.getProfile(userId: userID).asDriver(onErrorJustReturn: nil) }
        let isMine = UserManager.getInstance().map { $0 != nil && $0!.id == userID }.asDriver(onErrorJustReturn: false)
        let menuList = isMine.map { $0 ? [ProfileMenu.editProfile, ProfileMenu.changePassword, ProfileMenu.viewPostings, ProfileMenu.dangerZone] : [ProfileMenu.viewPostings] }
        let logoutResult = input.logoutTrigger.map { _ in
            UserManager.logout()
            return RequestResult(isSuccess: true, message: nil)
        }.asDriver()
        let selectedMenu = input.menuSelect.withLatestFrom(menuList) { indexPath, list in list[indexPath.row] }
        
        return Output(profile: profile, isMine: isMine, menuList: menuList, logoutResult: logoutResult, selectedMenu: selectedMenu)
    }
}
