//
//  ProfileNetwork.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import Foundation
import RxSwift
import RxCocoa

enum ProfileNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

struct ProfileNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchProfile(userID: Int) -> Single<Result<ProfileResponse, ProfileNetworkError>> {
        let urlString = "\(Constant.serverURL)/user/\(userID)"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL))}
        
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let result = try JSONDecoder().decode(ProfileResponse.self, from: data)
                    return .success(result)
                } catch {
                    return .failure(ProfileNetworkError.invalidJSON)
                }
            }
            .catch { _ in
                return .just(.failure(ProfileNetworkError.networkError))
            }
            .asSingle()
    }
}
