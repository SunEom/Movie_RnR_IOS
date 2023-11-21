//
//  SearchFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct DetailFactory {
    func getInstance(post: Post) -> DetailViewController {
        let vc = DetailViewController(viewModel: DetailViewModel(post))
        return vc
    }
}
