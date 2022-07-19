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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let postingManager = PostingManager()
    let commentManager = CommentManager()
    
    var postNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postingManager.delegate = self
        commentManager.delegate = self
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.CommentCellID)
        
        if let postNum = postNum {
            postingManager.fetchPostingDetail(postID: postNum)
            commentManager.fetchComment(postNum: postNum)
        }
        
    }
    
    
}

//MARK: - Posting Manager Delegate Methods

extension DetailViewController: PostingManagerDelegate {
    func didFetchPostingDetail(_ postingManager: PostingManager, detail: PostingDetail) {
        activityIndicator.stopAnimating()
        titleLabel.text = detail.movie.title
        genreLabel.text = detail.movie.genres
        rateLabel.text = "✭ \(detail.movie.rates) / 10"
        overviewTextView.text = detail.movie.overview
        dateLabel.text = String(detail.movie.created.split(separator: "T")[0])
        writerNicknameLabel.text = detail.user.nickname
    }
}

//MARK: - Comment Manager Delegate Method

extension DetailViewController: CommentManagerDelegate {
    func didFetchComments() {
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
}

//MARK: - Comment Table View Data Source Methods

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentManager.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.CommentCellID, for: indexPath) as! CommentTableViewCell
        
        cell.nicknameLabel.text = commentManager.comments[indexPath.row].nickname
        cell.contentsTextView.text = commentManager.comments[indexPath.row].contents
        cell.dateLabel.text = String(commentManager.comments[indexPath.row].created.split(separator: "T")[0])
        
        return cell
        
    }
}
