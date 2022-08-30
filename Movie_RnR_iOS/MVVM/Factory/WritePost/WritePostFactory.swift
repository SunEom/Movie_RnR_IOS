//
//  WritePostFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation

struct WritePostFactory {
    func getInstance(post: Post? = nil) -> WritePostViewController {
        let vc = WritePostViewController()
        vc.viewModel = WritePostViewModel(post: post)
        return vc
    }
}
