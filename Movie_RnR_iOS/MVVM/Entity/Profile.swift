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
    
    init(id: Int, nickname: String, gender: String, biography: String, facebook: String, instagram: String, twitter: String){
        self.id = id
        self.nickname = nickname
        self.gender = gender
        self.biography = biography
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
    }
}
