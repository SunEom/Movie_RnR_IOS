//
//  CommentEditViewFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/07.
//

import Foundation

struct CommentEditViewFactory {
    func getInstance(comment: Comment) -> CommentEditViewController {
        let vc = CommentEditViewController()
        vc.viewModel = CommentEditViewModel(comment: comment)
        return vc
    }
}
