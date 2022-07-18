//
//  PostManager.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/18.
//

import Foundation
import Alamofire

protocol PostingManagerRecentPostingsDelegate {
    func didUpdatePostings(_ postingManager: PostingManager, postings: [Posting])
}

protocol PostingManagerPostingDetailDelegate {
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail)
}

class PostingManager {
    var postings = [Posting]()
    
    var recentPostingsDelegate: PostingManagerRecentPostingsDelegate?
    var postingDetailDelegate: PostingManagerPostingDetailDelegate?
    
    func fetchRecentPost() {
    
        AF.request("\(ProcessInfo.processInfo.environment["ServerURL"]!)/post", method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: PostingResponse.self) { response in
                do {
                    let decoder = JSONDecoder()
                    if let safeData = response.data {
                        let decodedData = try decoder.decode(PostingResponse.self, from: safeData)
                        self.postings = decodedData.data
                        self.recentPostingsDelegate?.didUpdatePostings(self, postings: decodedData.data)
                    }
                } catch {
                    print("Error requesting HTTP: \(error)")
                }
                
            }
        
    }
    
    func fetchPostingDetail(postID: Int) {
        
        AF.request("\(ProcessInfo.processInfo.environment["ServerURL"]!)/post/\(postID)", method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: PostingDetailResponse.self) { response in
                do {
                    let decoder = JSONDecoder()
                    if let safeData = response.data {
                        let decodedData = try decoder.decode(PostingDetailResponse.self, from: safeData)
                        self.postingDetailDelegate?.didFetchPostingDetail(self, detail: decodedData.data)
                    }
                } catch {
                    print("Error requesting HTTP: \(error)")
                }
                
            }
    }
}
