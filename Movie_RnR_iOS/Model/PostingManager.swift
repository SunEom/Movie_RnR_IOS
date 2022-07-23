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
    func didFetchMyPostings(_ postingManager: PostingManager, postings: [Posting])
}

extension PostingManagerDelegate {
    func didUpdatePostings(_ postingManager: PostingManager, postings: [Posting]){}
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail){}
    func didFetchMyPostings(_ postingManager: PostingManager, postings: [Posting]){}
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
    
    func fetchMyPostings() {
        guard let id = UserManager.getInstance()?.id else { return }
        AF.request("\(Constant.serverURL)/post/user/\(id)", method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PostingResponse.self ) { response in
                if let res = response.value {
                    self.postings = res.data
                    self.delegate?.didFetchMyPostings(self, postings: self.postings)
                } else {
                    print("Error fetching my Postings: \(response.error)")
                }
            }
    }
}
