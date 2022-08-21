//
//  SearchFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct SearchFactory {
    func getInstance() -> SearchViewController {
        let vc = SearchViewController()
        vc.viewModel = SearchViewModel()
        return vc
    }
}
