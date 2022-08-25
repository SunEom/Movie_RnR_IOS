//
//  UserPostingFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation

struct UserPostingFactory {
    func getInstance(userID: Int) -> UserPostingViewController {
        let vc = UserPostingViewController()
        let vm = UserPostingViewModel(userID: userID)
        vc.viewModel = vm
        return vc
    }
}