//
//  HomeFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct WebFactory {
    func getInstance(url: String) -> WebViewController {
        let vc = WebViewController()
        vc.viewModel = WebViewModel(urlString: url)
        return vc
    }
}
