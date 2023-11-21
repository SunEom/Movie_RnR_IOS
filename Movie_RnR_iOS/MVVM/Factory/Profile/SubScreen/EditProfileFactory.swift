//
//  EditProfileFactory.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import Foundation

struct EditProfileFactory {
    func getInstance() -> EditProfileViewController {
        let vc = EditProfileViewController(viewModel: EditProfileViewModel())
        return vc
    }
}
