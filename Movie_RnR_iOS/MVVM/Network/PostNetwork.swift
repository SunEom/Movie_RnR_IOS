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
    case invalidQuery
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
    
    func searchPosts(query: String) -> Single<Result<PostResponse, PostNetworkError>> {
        let urlString = "\(Constant.serverURL)/search"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["keyword": query]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
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
        } catch {
            return .just(.failure(.invalidQuery))
        }
        
    }
    
    func fetchPostDetail(postID: Int) -> Single<Result<PostDetailRepsonse, PostNetworkError>> {
        let urlString = "\(Constant.serverURL)/post/\(postID)"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL)) }
        
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                
                do {
                    let response = try JSONDecoder().decode(PostDetailRepsonse.self, from: data)
                    
                    return .success(response)
                } catch {
                    return .failure(PostNetworkError.invalidJSON)
                }
                
            }
            .catch { _ in
                return .just(.failure(PostNetworkError.networkError))
            }
            .asSingle()
    }
    
    func fetchUserPostings(userID: Int) -> Single<Result<PostResponse, PostNetworkError>> {
        let urlString = "\(Constant.serverURL)/post/user/\(userID)"
        
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
