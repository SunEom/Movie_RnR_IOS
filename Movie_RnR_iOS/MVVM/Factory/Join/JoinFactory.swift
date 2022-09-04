//
//  JoinFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import Foundation

struct JoinFactory {
    func getInstance() -> JoinViewController {
        let vc = JoinViewController()
        vc.viewModel = JoinViewModel()
        return vc
    }
}
