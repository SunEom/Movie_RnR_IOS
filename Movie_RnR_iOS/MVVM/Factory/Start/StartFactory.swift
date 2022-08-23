//
//  StartFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import Foundation

struct StartFactory {
    func getInstance() -> StartViewController {
        let vc = StartViewController()
        vc.viewModel = StartViewModel()
        return vc
    }
}
