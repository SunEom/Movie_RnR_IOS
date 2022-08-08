//
//  PostNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import RxSwift

enum PostNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

struct PostNetwork {
    
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecentPosts() -> Single<Result<PostResponse, PostNetworkError>> {
        let urlString = "\(Constant.serverURL)/post"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let decodedData = try JSONDecoder().decode(PostResponse.self, from: data)
                    return .success(decodedData)
                } catch {
                    return .failure(PostNetworkError.invalidJSON)
                }
            }
            .catch { _ in
                return .just(.failure(PostNetworkError.networkError))
            }
            .asSingle()
    }
}
