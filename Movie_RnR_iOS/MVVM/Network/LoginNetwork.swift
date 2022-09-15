//
//  LoginNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/13.
//

import Foundation
import RxSwift

struct LoginNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func requestPostLogin(id: String, password: String) -> Single<Result<LoginResponse, NetworkError>> {
        let urlString = "\(Constant.serverURL)/auth/login"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["id": id, "password": password]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(LoginResponse.self, from: data)
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
    
    func requestGetLogin() -> Single<Result<LoginResponse, NetworkError>> {
        let urlString = "\(Constant.serverURL)/auth/login"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL))}
        
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                    return .success(result)
                } catch {
                    return .failure(NetworkError.invalidJSON)
                }
            }
            .catch { _ in
                return .just(.failure(NetworkError.networkError))
            }
            .asSingle()
    }
}
