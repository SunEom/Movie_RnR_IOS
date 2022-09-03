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
    case invalidQuery
}

struct ProfileNetwork {
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func requestNicknameCheck(nickname: String) -> Single<Result<NicknameResponse, ProfileNetworkError>> {
        let urlString = "\(Constant.serverURL)/join/nick"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["nickname": nickname]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(NicknameResponse.self, from: data)
                        return .success(decodedData)
                    } catch {
                        return .failure(ProfileNetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(ProfileNetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
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
    
    func updateProfile(with profile: Profile) -> Single<Result<ProfileResponse, ProfileNetworkError>> {
        let urlString = "\(Constant.serverURL)/user/profile"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["nickname": profile.nickname, "gender": profile.gender, "biography": profile.biography, "facebook": profile.facebook, "instagram": profile.instagram, "twitter": profile.twitter]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(ProfileResponse.self, from: data)
                        return .success(decodedData)
                    } catch {
                        return .failure(ProfileNetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(ProfileNetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
    }
    
    func updatePassword(password: String, newPassword: String) -> Single<Result<DefaultResponse, ProfileNetworkError>> {
        let urlString = "\(Constant.serverURL)/user/password"
        
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidURL))
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter = ["password": password, "newPassword": newPassword]
            
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter)
            
            return session.rx.data(request: request)
                .map { data in
                    do {
                        let decodedData = try JSONDecoder().decode(DefaultResponse.self, from: data)
                        if decodedData.code == 201 {
                            UserManager.requestGetLogin()
                            UserDefaults.standard.set(newPassword, forKey: "password")
                        }
                        return .success(decodedData)
                    } catch {
                        return .failure(ProfileNetworkError.invalidJSON)
                    }
                }
                .catch { _ in
                    return .just(.failure(ProfileNetworkError.networkError))
                }
                .asSingle()
        } catch {
            return .just(.failure(.invalidQuery))
        }
    }
    

    func deleteAccount() -> Single<Result<DefaultResponse, ProfileNetworkError>> {
        let urlString = "\(Constant.serverURL)/user"
        
        guard let url = URL(string: urlString) else { return .just(.failure(.invalidURL)) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return session.rx.data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(DefaultResponse.self, from: data)
                    
                    if response.code == 200 {
                        UserDefaults.standard.removeObject(forKey: "id")
                        UserDefaults.standard.removeObject(forKey: "password")
                    }
                    
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
