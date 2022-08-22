//
//  SearchFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct ProfileFactory {
    func getInstance() -> ProfileViewController {
        let vc = ProfileViewController()
        vc.viewModel = ProfileViewModel()
        return vc
    }
}
