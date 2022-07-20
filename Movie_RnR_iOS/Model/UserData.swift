//
//  Login.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import Foundation

class LoginResponse: Decodable {
    let code: Int
    let data: UserData?
    let error: String?
}

class UserData: Decodable {
    private let id: Int
    private let password: String
    private let nickname: String
    private let gender: String
    private let aboutId: Int
    private let biography: String
    private let instagram: String
    private let facebook: String
    private let twitter: String
    private let my_id: Int
}
