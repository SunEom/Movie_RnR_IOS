//
//  JoinViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import Foundation
import RxCocoa
import RxSwift

struct JoinViewModel {

    let genderList = Driver<[String]>.of(["None","Man","Woman"])
    
}
