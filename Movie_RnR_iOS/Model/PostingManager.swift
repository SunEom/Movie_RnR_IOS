//
//  PostManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/18.
//

import Foundation
import Alamofire

protocol PostingManagerDelegate {
    func didUpdatePostings(_ postingManager: PostingManager, postings: [Posting])
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail)
}

extension PostingManagerDelegate {
    func didUpdatePostings(_ postingManager: PostingManager, postings: [Posting]){}
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail){}
}

class PostingManager {
    var postings = [Posting]()
    
    var delegate: PostingManagerDelegate?
    
    func fetchRecentPost() {
    
        AF.request("\(Constant.serverURL)/post", method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: PostingResponse.self) { response in
                do {
                    let decoder = JSONDecoder()
                    if let safeData = response.data {
                        let decodedData = try decoder.decode(PostingResponse.self, from: safeData)
                        self.postings = decodedData.data
                        self.delegate?.didUpdatePostings(self, postings: decodedData.data)
                    }
                } catch {
                    print("Error requesting HTTP: \(error)")
                }
                
            }
        
    }
    
    func fetchPostingDetail(postID: Int) {
        
        AF.request("\(Constant.serverURL)/post/\(postID)", method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: PostingDetailResponse.self) { response in
                do {
                    let decoder = JSONDecoder()
                    if let safeData = response.data {
                        let decodedData = try decoder.decode(PostingDetailResponse.self, from: safeData)
                        self.delegate?.didFetchPostingDetail(self, detail: decodedData.data)
                    }
                } catch {
                    print("Error requesting HTTP: \(error)")
                }
                
            }
    }
}
