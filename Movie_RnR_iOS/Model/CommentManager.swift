//
//  CommentManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import Foundation
import Alamofire

class CommentManager {
    
    var comments = [Comment]()
    
    func fetchComment(postNum: Int) {
        AF.request("\(ProcessInfo.processInfo.environment["ServerURL"]!)/comment/\(postNum)")
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentResponse.self) { response in
                if let res = response.value {
                    self.comments = res.data
                    print(self.comments)
                } else {
                    print("Error fetching comments: \(response.error)")
                }
            }
    }
}
