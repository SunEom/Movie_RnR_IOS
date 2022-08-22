//
//  ChangePasswordFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation

struct ChangePasswordFactory {
    func getInstance() -> ChangePasswordViewController {
        let vc = ChangePasswordViewController()
        vc.viewModel = ChangePasswordViewModel()
        return vc
    }
}

