//
//  HomeFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct HomeFactory {
    func getInstance() -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel()
        return vc
    }
}
