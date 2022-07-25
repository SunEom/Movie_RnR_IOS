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

class UserUpdateResponse: Decodable {
    let code: Int
    let data: [UserData]?
    let error: String?
}

class UserUpdateRequest {
    let nickname: String
    let gender : String
    let biography: String
    let instagram: String
    let facebook: String
    let twitter: String
    
    init(nickname: String, gender: String, biography: String, facebook: String, instagram: String, twitter: String){
        self.nickname = nickname
        self.gender = gender
        self.biography = biography
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
    }
}
