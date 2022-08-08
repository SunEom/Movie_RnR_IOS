//
//  JoinData.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/25.
//

import Foundation

class CheckResponse: Decodable {
    let already: Bool
}

class JoinResponse: Decodable {
    let code: Int
}
