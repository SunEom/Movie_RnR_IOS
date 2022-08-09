//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit

class CommentListCell: UITableViewCell {
    
    let topStackView = UIStackView()
    let titleLabel = UILabel()
    let commentInputStackView = UIStackView()
    let commentTextView = UITextView()
    let commentButton = UIButton()
    let tableView = UITableView()
    
    func setUp() {
    
        backgroundColor = UIColor(named: "mainColor")
        
        topStackView.axis = .vertical
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(commentInputStackView)
        topStackView.addArrangedSubview(tableView)
        topStackView.spacing = 10
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "CarterOne", size: 20)
        titleLabel.text = "Comments"
        
        commentInputStackView.addArrangedSubview(commentTextView)
        commentInputStackView.addArrangedSubview(commentButton)
        commentInputStackView.alignment = .fill
        
        commentTextView.textColor = .black
        commentTextView.backgroundColor = .white
        
        commentButton.backgroundColor = UIColor(named: "headerColor")
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.setTitle("Save", for: .normal)
        
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor(named: "mainColor")
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        
        [topStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        [
            topStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            topStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            commentInputStackView.heightAnchor.constraint(equalToConstant: 100),
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            
            heightAnchor.constraint(equalTo: topStackView.heightAnchor)
            
        ].forEach { $0.isActive = true}
        
        
        
    }
    
}
