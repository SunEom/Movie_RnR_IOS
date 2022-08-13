//
//  LoginNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/13.
//

import Foundation
import RxSwift

enum LoginNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    case invalidQuery
}

struct LoginNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func requestPostLogin(id: String, password: String) -> Single<Result<LoginResponse, LoginNetworkError>> {
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
                        return .failure(LoginNetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(LoginNetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
    }
}
