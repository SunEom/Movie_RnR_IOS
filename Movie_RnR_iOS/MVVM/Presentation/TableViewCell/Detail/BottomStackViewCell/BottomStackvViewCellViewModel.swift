//
//  BottomStackvViewCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/11.
//

import RxSwift
import RxCocoa

struct BottomStackViewCellViewModel {
    let date = PublishSubject<String?>()
    let nickname = PublishSubject<String?>()
}
