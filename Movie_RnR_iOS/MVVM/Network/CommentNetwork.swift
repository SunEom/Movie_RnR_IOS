//
//  CommentNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import Foundation
import RxSwift

struct CommentNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchComments(postID: Int) -> Single<Result<CommentResponse, NetworkError>> {
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
    
    func createNewComment(with data: (id: Int, contents: String) ) -> Single<Result<CommentResponse, NetworkError>> {
        let urlString = "\(Constant.serverURL)/comment"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["movie_id": "\(data.id)", "contents": data.contents]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(CommentResponse.self, from: data)
                        return .success(decodedData)
                    } catch {
                        return .failure(NetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(NetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
        
    }
    
    func deleteComment(commentID: Int) -> Single<Result<CommentDeleteResponse, NetworkError>> {
        let urlString = "\(Constant.serverURL)/comment/\(commentID)"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL)) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(CommentDeleteResponse.self, from: data)
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
    
    func updateComment(with data: (CommentId: Int, contents: String) ) -> Single<Result<CommentEditResponse, NetworkError>> {
        let urlString = "\(Constant.serverURL)/comment/update"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            let parameter = ["id": "\(data.CommentId)", "contents": data.contents]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(CommentEditResponse.self, from: data)
                        return .success(decodedData)
                    } catch {
                        return .failure(NetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(NetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
        
    }
    
}
