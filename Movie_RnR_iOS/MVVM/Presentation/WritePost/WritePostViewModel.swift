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
    let disposeBag = DisposeBag()
    
    var post: Post? = nil
    
    let title = BehaviorSubject<String>(value: "")
    
    let romance = BehaviorSubject<Bool>(value: false)
    let action = BehaviorSubject<Bool>(value: false)
    let comedy = BehaviorSubject<Bool>(value: false)
    let historical = BehaviorSubject<Bool>(value: false)
    let horror = BehaviorSubject<Bool>(value: false)
    let sf = BehaviorSubject<Bool>(value: false)
    let thriller = BehaviorSubject<Bool>(value: false)
    let mystery = BehaviorSubject<Bool>(value: false)
    let animation = BehaviorSubject<Bool>(value: false)
    let drama = BehaviorSubject<Bool>(value: false)
    
    let rate = BehaviorSubject<Double>(value: 0)
    let overview = BehaviorSubject<String>(value: "")
    
    let saveButtonTap = PublishSubject<Void>()

    let alert = PublishSubject<(title: String, message: String)>()
    
    init(post: Post? = nil) {
        
        // 게시글 수정의 경우 기존 값 초기화
        if post != nil {
            self.post = post
            
            title.onNext(post!.title)
        
            romance.onNext(post!.genres.lowercased().contains("romance"))
            action.onNext(post!.genres.lowercased().contains("cction"))
            comedy.onNext(post!.genres.lowercased().contains("comedy"))
            historical.onNext(post!.genres.lowercased().contains("historical"))
            horror.onNext(post!.genres.lowercased().contains("horror"))
            sf.onNext(post!.genres.lowercased().contains("sci-fi"))
            thriller.onNext(post!.genres.lowercased().contains("thriller"))
            mystery.onNext(post!.genres.lowercased().contains("mystery"))
            animation.onNext(post!.genres.lowercased().contains("animation"))
            drama.onNext(post!.genres.lowercased().contains("drama"))
            
            rate.onNext(post!.rates)
            overview.onNext(post!.overview)
        }
        
        
        let genres1 = Observable
            .combineLatest(romance, action, comedy, historical, horror, sf)
    
        genres1.subscribe(onNext:{
            print($0)
        })
        .disposed(by: disposeBag)
            
        let genres2 = Observable
            .combineLatest(sf, thriller, mystery, animation, drama)
    
        let genreString = Observable.combineLatest(genres1, genres2) {
            return ($0.0, $0.1, $0.2, $0.3, $0.4, $1.0, $1.1, $1.2, $1.3, $1.4)
        }
        .map { (romance, action, comedy, historical, horror, sf, thriller, mystery, animation, drama) -> String in
            var result = ""
            
            if romance {
                result += "Romance, "
            }
            
            if action {
                result  += "Action, "
            }

            if comedy {
                result += "Comedy, "
            }
            
            if historical {
                result += "Historical, "
            }
            
            if horror {
                result += "Horror, "
            }
            
            if sf {
                result += "Sci-Fi, "
            }
            
            if thriller {
                result += "Thriller, "
            }
            
            if mystery {
                result += "Mystery, "
            }
            
            if animation {
                result += "Animation, "
            }
            
            if drama {
                result += "Drama, "
            }
            
            if result != "" {
                result.removeLast(2)
            }
            
            
            return result
        }

        let inputData = Observable
            .combineLatest(title, genreString, rate, overview )

        
        
        // 입력 값 확인 결과 - 실패
        saveButtonTap
            .withLatestFrom(inputData)
            .filter { (title, genre, rate, overview) in
                return title == "" || genre == "" || rate == 0.0 || overview == ""
            }
            .map { (title, genre, rate, overview) -> (String, String) in
                if title == "" {
                    return ("실패", "제목을 입력해주세요.")
                }
                else if genre == "" {
                    return ("실패", "1개 이상의 장르를 선택해주세요.")
                }
                else if rate == 0.0 {
                    return ("실패" ,"0.1점 이상의 평점을 입력해주세요.")
                }
                else if overview == "" {
                    return ("실패", "게시글 내용을 입력해주세요.")
                }
                else {
                    return ("실패", "처리중 오류가 발생하였습니다.")
                }
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        
        // 입력값 확인 결과 - 성공
        
        let inputCheckSuccess = saveButtonTap
            .withLatestFrom(inputData)
            .filter { (title, genre, rate, overview) in
                return !(title == "" || genre == "" || rate == 0.0 || overview == "")
            }
        
        // 게시글 작성의 경우
        inputCheckSuccess
            .filter { _ in
                return post == nil
            }
            .flatMapLatest(PostNetwork().createNewPost)
            .map { result -> (String, String) in
                guard case .success( _) = result else { return ("실패", "게시글 작성에 실패하였습니다.") }
                return ("성공", "게시글이 저장되었습니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
        
        //게시글 수정의 경우
        inputCheckSuccess
            .filter { _ in
                return post != nil
            }
            .flatMapLatest(PostNetwork().createNewPost)
            .map { result -> (String, String) in
                guard case .success( _) = result else { return ("실패", "게시글 작성에 실패하였습니다.") }
                return ("성공", "게시글이 수정되었습니다.")
            }
            .bind(to: alert)
            .disposed(by: disposeBag)
    }
    
}
