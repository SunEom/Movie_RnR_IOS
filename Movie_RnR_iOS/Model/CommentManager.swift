//
//  CommentManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import Foundation
import Alamofire

protocol CommentManagerDelegate {
    func didFetchComments()
}

extension CommentManagerDelegate {
    func didFetchComments(){}
}

class CommentManager {
    
    var comments = [Comment]()
    
    var delegate: CommentManagerDelegate?
    
    func fetchComment(postNum: Int) {
        AF.request("\(Constant.serverURL)/comment/\(postNum)")
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentResponse.self) { response in
                if let res = response.value {
                    self.comments = res.data
                    self.delegate?.didFetchComments()
                } else {
                    print("Error fetching comments: \(String(describing: response.error))")
                }
            }
    }
    
    func newComment(postNum: Int, contents: String) {
        AF.request("\(Constant.serverURL)/comment", method: .post, parameters: ["movie_id": postNum, "contents": contents])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentResponse.self) { response in
                if let res = response.value {
                    self.comments = res.data
                    self.fetchComment(postNum: postNum)
                } else {
                    print("Error fetching comments: \(String(describing: response.error))")
                }
            }
    }
    
    func deleteComment(commentId: Int, postNum: Int) {
        AF.request("\(Constant.serverURL)/comment/\(commentId)", method: .delete)
            .validate(statusCode: 200..<300)
            .response { response in
                self.fetchComment(postNum: postNum)
            }
    }
    
    func updateComment(commentId: Int, contents: String, postNum: Int) {
        AF.request("\(Constant.serverURL)/comment/update", method: .patch, parameters: ["id": commentId, "contents": contents])
            .validate(statusCode: 200..<300)
            .response { response in
                self.fetchComment(postNum: postNum)
            }
    }
}
