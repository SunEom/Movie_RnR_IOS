//
//  UserPostingFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation

struct DangerZoneFactory {
    func getInstance() -> DangerZoneViewController {
        let vc = DangerZoneViewController()
        vc.viewModel = DangerZoneViewModel()
        return vc
    }
}
