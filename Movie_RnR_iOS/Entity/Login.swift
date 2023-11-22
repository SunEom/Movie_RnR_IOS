//
//  User.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/13.
//

import Foundation

struct LoginResponse: Decodable {
    let code: Int
    let data: Login?
    let error: String?
}

struct Login: Decodable {
    let id: Int
    let password: String
    let nickname: String
    let gender: String
    let aboutId: Int
    let biography: String
    let instagram: String
    let facebook: String
    let twitter: String
    let my_id: Int
}
