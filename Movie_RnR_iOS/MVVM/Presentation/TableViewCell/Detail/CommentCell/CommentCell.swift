//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit

class CommentCell: UITableViewCell {

    let nicknameLabel = UILabel()
    let contentsTextView = UITextView()
    let dateLabel = UILabel()
    
    func setUp(comment: Comment) {
        // attribute
        backgroundColor = UIColor(named: "mainColor")
          
        nicknameLabel.text = comment.nickname
        contentsTextView.text = comment.contents
        dateLabel.text = dateFormat(with: comment.created)
        
        nicknameLabel.textColor = .black
        nicknameLabel.font = .systemFont(ofSize: 13)
        
        contentsTextView.textColor = .black
        contentsTextView.font = .systemFont(ofSize: 13)
        contentsTextView.isScrollEnabled = false
        contentsTextView.backgroundColor = UIColor(named: "mainColor")
        contentsTextView.textContainer.lineFragmentPadding = 0
        
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 10)
        
        // layout

        [nicknameLabel, contentsTextView, dateLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            nicknameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            contentsTextView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentsTextView.bottomAnchor),
        
            bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
        ].forEach { $0.isActive = true }
    }
    
    private func dateFormat(with: String) -> String {
        return String(with.split(separator: "T")[0])
    }
}
