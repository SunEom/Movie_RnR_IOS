//
//  JoinNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/05.
//

import Foundation
import RxSwift

struct JoinNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func requestJoin(with data : (id: String, password: String, nickname: String, gender: String)) -> Single<Result< LoginResponse ,NetworkError>> {
        
        let urlString = "\(Constant.serverURL)/join"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["id": data.id, "password": data.password, "nickname": data.nickname, "gender": data.gender]
            
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
}
