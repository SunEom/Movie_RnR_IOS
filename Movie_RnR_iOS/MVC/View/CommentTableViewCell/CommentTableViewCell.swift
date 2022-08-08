//
//  CommentTableViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var baseStackView: UIStackView!
    @IBOutlet weak var editStackView: UIStackView!
    
    var commentId: Int?
    var postNum: Int?
    var commentManager: CommentManager?
    var vc: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentsTextView.textContainer.lineFragmentPadding = 0
        contentsTextView.textContainerInset = .zero
        
        baseStackView.isHidden = true
        editStackView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.baseStackView.isHidden = true
            self.editStackView.isHidden = false
            self.contentsTextView.isEditable = true
            self.contentsTextView.backgroundColor = .white
            self.contentsTextView.isScrollEnabled = true
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        guard let postNum = postNum else {
            return
        }
        guard let commentId = commentId else {
            return
        }
        
        let alert = UIAlertController(title: "삭제 확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.commentManager?.deleteComment(commentId: commentId, postNum: postNum)
        }
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        vc?.present(alert, animated: true)
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        guard let id = commentId else { return }
        guard let contents = contentsTextView.text else { return }
        guard let postNum = postNum else { return }
        
        DispatchQueue.main.async {
            self.baseStackView.isHidden = false
            self.editStackView.isHidden = true
            self.contentsTextView.isEditable = false
            self.contentsTextView.backgroundColor = UIColor(named: "mainColor")
            self.contentsTextView.isScrollEnabled = false
        }
        
        commentManager?.updateComment(commentId: id, contents: contents, postNum: postNum)
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.baseStackView.isHidden = false
            self.editStackView.isHidden = true
            self.contentsTextView.isEditable = false
            self.contentsTextView.backgroundColor = UIColor(named: "mainColor")
            self.contentsTextView.isScrollEnabled = false
        }
    }
    
    
}
