//
//  Profile.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import Foundation

struct ProfileResponse: Decodable {
    let code: Int
    let data: [Profile]
}

struct Profile: Decodable {
    let id: Int
    let nickname: String
    let gender: String
    let biography: String
    let instagram: String
    let facebook: String
    let twitter: String
}
