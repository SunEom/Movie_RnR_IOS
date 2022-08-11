//
//  TopStackViewCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/11.
//

import RxCocoa
import RxSwift

struct TopStackViewCellViewModel {
    let genres = PublishSubject<String?>()
    let rates = PublishSubject<String?>()
}
