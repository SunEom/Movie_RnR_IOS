//
//  CommentNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import Foundation
import RxSwift

enum CommentNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

struct CommentNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchComments(postID: Int) -> Single<Result<CommentResponse, CommentNetworkError>> {
        let urlString = "\(Constant.serverURL)/comment/\(postID)"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL)) }
        
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(CommentResponse.self, from: data)
                    return .success(response)
                } catch {
                    return .failure(.invalidJSON)
                }
                
            }
            .catch { _ in
                return .just(.failure(.networkError))
            }
            .asSingle()
    }
}
