//
//  SearchFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct LoginFactory {
    func getInstance() -> LoginViewController {
        let vc = LoginViewController(viewModel: LoginViewModel())
        return vc
    }
}
