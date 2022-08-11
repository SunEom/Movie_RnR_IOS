//
//  TitleViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/11.
//

import RxSwift
import RxCocoa

struct TitleCellViewModel {
    let title = PublishSubject<String?>()
}
