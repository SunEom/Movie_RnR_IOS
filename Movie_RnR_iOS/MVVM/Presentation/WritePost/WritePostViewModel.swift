//
//  WritePostViewModel.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import RxSwift
import RxCocoa
import CoreText

struct WritePostViewModel {
    private let disposeBag = DisposeBag()
    private let repository: PostRepository
    private let post: Post?
    
    struct Input {
        let title: Driver<String>

        let romanceTrigger: Driver<Void>
        let actionTrigger: Driver<Void>
        let comedyTrigger: Driver<Void>
        let historicalTrigger: Driver<Void>
        let horrorTrigger: Driver<Void>
        let sfTrigger: Driver<Void>
        let thrillerTrigger: Driver<Void>
        let mysteryTrigger: Driver<Void>
        let animationTrigger: Driver<Void>
        let dramaTrigger: Driver<Void>
        
        let rate: Driver<Double>
        let overview: Driver<String>
        
        let writeTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
    }
    
    struct Output {
        let post: Post?
        
        let romance: Driver<Bool>
        let action: Driver<Bool>
        let comedy: Driver<Bool>
        let historical: Driver<Bool>
        let horror: Driver<Bool>
        let sf: Driver<Bool>
        let thriller: Driver<Bool>
        let mystery: Driver<Bool>
        let animation: Driver<Bool>
        let drama: Driver<Bool>
        
        let result: Driver<RequestResult>
        let deletResult: Driver<RequestResult>
    }

    init(post: Post? = nil, _ repository: PostRepository = PostRepository()) {
        self.post = post
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        let romanceState = BehaviorSubject<Bool>(value: false)
        let actionState = BehaviorSubject<Bool>(value: false)
        let comedyState = BehaviorSubject<Bool>(value: false)
        let historicalState = BehaviorSubject<Bool>(value: false)
        let horrorState = BehaviorSubject<Bool>(value: false)
        let sfState = BehaviorSubject<Bool>(value: false)
        let thrillerState = BehaviorSubject<Bool>(value: false)
        let mysteryState = BehaviorSubject<Bool>(value: false)
        let animationState = BehaviorSubject<Bool>(value: false)
        let dramaState = BehaviorSubject<Bool>(value: false)
        
        if let post = post {
            
            if post.genres.lowercased().contains("romance"){
                romanceState.onNext(true)
            }
            
            if post.genres.lowercased().contains("action"){
                actionState.onNext(true)
            }
            
            if post.genres.lowercased().contains("comedy"){
                comedyState.onNext(true)
            }
            
            if post.genres.lowercased().contains("historical"){
                historicalState.onNext(true)
            }
            
            if post.genres.lowercased().contains("horror"){
                horrorState.onNext(true)
            }
            
            if post.genres.lowercased().contains("sci-fi"){
                sfState.onNext(true)
            }
            
            if post.genres.lowercased().contains("thriller"){
                thrillerState.onNext(true)
            }
            
            if post.genres.lowercased().contains("mystery"){
                mysteryState.onNext(true)
            }
            
            if post.genres.lowercased().contains("animation"){
                animationState.onNext(true)
            }
            
            if post.genres.lowercased().contains("drama"){
                dramaState.onNext(true)
            }
            
        }
        
        input.romanceTrigger
            .asObservable()
            .withLatestFrom(romanceState)
            .map { !$0 }
            .bind(to: romanceState)
            .disposed(by: disposeBag)
        
        input.actionTrigger
            .asObservable()
            .withLatestFrom(actionState)
            .map { !$0 }
            .bind(to: actionState)
            .disposed(by: disposeBag)
        
        input.comedyTrigger
            .asObservable()
            .withLatestFrom(comedyState)
            .map { !$0 }
            .bind(to: comedyState)
            .disposed(by: disposeBag)
        
        input.historicalTrigger
            .asObservable()
            .withLatestFrom(historicalState)
            .map { !$0 }
            .bind(to: historicalState)
            .disposed(by: disposeBag)
        
        input.horrorTrigger
            .asObservable()
            .withLatestFrom(horrorState)
            .map { !$0 }
            .bind(to: horrorState)
            .disposed(by: disposeBag)
        
        input.sfTrigger
            .asObservable()
            .withLatestFrom(sfState)
            .map { !$0 }
            .bind(to: sfState)
            .disposed(by: disposeBag)
        
        input.thrillerTrigger
            .asObservable()
            .withLatestFrom(thrillerState)
            .map { !$0 }
            .bind(to: thrillerState)
            .disposed(by: disposeBag)
        
        input.mysteryTrigger
            .asObservable()
            .withLatestFrom(mysteryState)
            .map { !$0 }
            .bind(to: mysteryState)
            .disposed(by: disposeBag)
        
        input.animationTrigger
            .asObservable()
            .withLatestFrom(animationState)
            .map { !$0 }
            .bind(to: animationState)
            .disposed(by: disposeBag)
        
        input.dramaTrigger
            .asObservable()
            .withLatestFrom(dramaState)
            .map { !$0 }
            .bind(to: dramaState)
            .disposed(by: disposeBag)
    
        let genreString = Observable.combineLatest(Observable.combineLatest(romanceState, actionState, comedyState, historicalState, horrorState), Observable.combineLatest(sfState, thrillerState, mysteryState, animationState, dramaState))
            .map { (genres1, genres2) in
                let (romance, action, comedy, historical, horror) = genres1
                let (sf, thriller, mystery, animation, drama) = genres2
                
                var genres = [String]()
                
                
                if romance { genres.append("Romance") }
                if action { genres.append("Action") }
                if comedy { genres.append("Comedy") }
                if historical { genres.append("Historical") }
                if horror { genres.append("Horror") }
                if sf { genres.append("Sci-Fi") }
                if thriller { genres.append("Thriller") }
                if mystery { genres.append("Mystery") }
                if animation { genres.append("Animation") }
                if drama { genres.append("Drama") }
                
                return genres.joined(separator: ", ")
            }
            .asDriver(onErrorJustReturn: "")
        
        let result = input.writeTrigger
            .filter { post == nil }
            .withLatestFrom(Driver.combineLatest(input.title, genreString, input.rate, input.overview))
            .flatMapLatest { title, genre, rate, overview in
                if post == nil {
                    repository.createNewPost(title: title, genres: genre, rates: rate, overview: overview)
                        .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))
                } else {
                    repository.updatePost(id: post!.id, title: title, genres: genre, rates: rate, overview: overview)
                        .asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil))
                }
                
            }
        
        let deleteResult = input.deleteTrigger
            .flatMapLatest { repository.deletePost(postID: post!.id).asDriver(onErrorJustReturn: RequestResult(isSuccess: false, message: nil)) }
            
        
        return Output(post: post,
                      romance: romanceState.asDriver(onErrorJustReturn: false),
                      action: actionState.asDriver(onErrorJustReturn: false),
                      comedy: comedyState.asDriver(onErrorJustReturn: false),
                      historical: historicalState.asDriver(onErrorJustReturn: false),
                      horror: horrorState.asDriver(onErrorJustReturn: false),
                      sf: sfState.asDriver(onErrorJustReturn: false),
                      thriller: thrillerState.asDriver(onErrorJustReturn: false),
                      mystery: mysteryState.asDriver(onErrorJustReturn: false),
                      animation: animationState.asDriver(onErrorJustReturn: false),
                      drama: dramaState.asDriver(onErrorJustReturn: false),
                      result: result,
                      deletResult: deleteResult)
    }
    
}
