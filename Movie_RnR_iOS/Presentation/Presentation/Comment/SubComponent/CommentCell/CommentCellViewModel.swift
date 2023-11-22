//
//  CommentCellViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/01.
//
import Foundation
import RxSwift
import RxCocoa

struct CommentCellViewModel {
    
    private let disposeBag = DisposeBag()
    private let repository: CommentRepository
    private let parentVM: CommentViewModel
    private let comment: Comment
    
    struct Input {
        
    }
    
    struct Output {
        let comment: Comment
    }
    
    init(vm: CommentViewModel, comment: Comment, repository: CommentRepository = CommentRepository()) {
        self.repository = repository
        self.parentVM = vm
        self.comment = comment
    }
    
    func transform() -> Output {
        return Output(comment: comment)
    }
}
