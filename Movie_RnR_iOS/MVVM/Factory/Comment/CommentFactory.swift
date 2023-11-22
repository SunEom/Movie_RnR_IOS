//
//  HomeFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/21.
//

import Foundation

struct CommentFactory {
    func getInstance(postID: Int) -> CommentViewController {
        let vc = CommentViewController(viewModel: CommentViewModel(postID: postID))
        return vc
    }
}
