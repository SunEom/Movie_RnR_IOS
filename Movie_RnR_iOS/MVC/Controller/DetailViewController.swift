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
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentSaveButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    
    let postingManager = PostingManager()
    let commentManager = CommentManager()
    
    var postNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postingManager.delegate = self
        commentManager.delegate = self
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Comment)
        
        if let postNum = postNum {
            postingManager.fetchPostingDetail(postID: postNum)
            commentManager.fetchComment(postNum: postNum)
        }
        
        if UserManager.getInstance() == nil {
            commentTextView.isEditable = false
            commentTextView.text = "로그인을 해주세요."
            commentTextView.textColor = .gray
            commentSaveButton.isEnabled = false
        }
        
    }
    
    @IBAction func commentSavePressed(_ sender: UIButton) {
        guard let contents = commentTextView.text else { return }
        guard let postNum = postNum else {
            return
        }

        if contents.count == 0 {
            let alert = UIAlertController(title: "입력 오류", message: "댓글 내용을 입력해주세요", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            present(alert, animated: true)
            
            return
        }
        
        commentManager.newComment(postNum: postNum, contents: contents)
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
            self.commentTableViewHeight.constant = self.commentTableView.contentSize.height
        }
    }
}

//MARK: - Comment Table View Data Source Methods

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentManager.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Comment, for: indexPath) as! CommentTableViewCell
        
        let comment = commentManager.comments[indexPath.row]
        
        cell.postNum = self.postNum
        cell.commentId = comment.id
        cell.commentManager = self.commentManager
        cell.vc = self
        
        cell.nicknameLabel.text = comment.nickname
        cell.contentsTextView.text = comment.contents
        cell.dateLabel.text = String(comment.created.split(separator: "T")[0])
        
        if let user = UserManager.getInstance(), comment.commenter == user.id {
            cell.baseStackView.isHidden = false
        }
        
        DispatchQueue.main.async {
            self.commentTableViewHeight.constant = self.commentTableView.contentSize.height
        }
        
        return cell
        
    }
}
