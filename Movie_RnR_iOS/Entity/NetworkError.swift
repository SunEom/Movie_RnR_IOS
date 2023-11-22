//
//  NetworkError.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/15.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "잘못된 URL 입니다."
    case invalidJSON = "잘못된 JSON 형식입니다."
    case networkError = "네트워크 에러입니다."
    case invalidQuery = "잘못된 Parameter 입니다."
}
