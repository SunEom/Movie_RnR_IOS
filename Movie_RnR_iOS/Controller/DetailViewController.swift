//
//  DetailViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/18.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var writerNicknameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let postingManager = PostingManager()
    let commentManager = CommentManager()
    
    var postNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postingManager.postingDetailDelegate = self
        
        if let postNum = postNum {
            postingManager.fetchPostingDetail(postID: postNum)
            commentManager.fetchComment(postNum: postNum)
        }
        
    }
    

}

extension DetailViewController: PostingManagerPostingDetailDelegate {
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail) {
        activityIndicator.stopAnimating()
        titleLabel.text = detail.movie.title
        genreLabel.text = detail.movie.genres
        rateLabel.text = "✭ \(detail.movie.rates) / 10"
        overviewTextView.text = detail.movie.overview
        dateLabel.text = String(detail.movie.created.split(separator: "T")[0])
        writerNicknameLabel.text = detail.user.nickname
        
        overviewTextView.translatesAutoresizingMaskIntoConstraints = true
        overviewTextView.sizeToFit()
        

    }
}

