//
//  WritePostViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa

struct WritePostViewModel {
    
    var post: Post!
    
    let romance = PublishSubject<Bool>()
    let action = PublishSubject<Bool>()
    let comedy = PublishSubject<Bool>()
    let historical = PublishSubject<Bool>()
    let horror = PublishSubject<Bool>()
    let sf = PublishSubject<Bool>()
    let thriller = PublishSubject<Bool>()
    let mystery = PublishSubject<Bool>()
    let animation = PublishSubject<Bool>()
    let drama = PublishSubject<Bool>()
    
}
