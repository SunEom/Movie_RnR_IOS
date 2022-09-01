//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift

class CommentCellViewController: UITableViewCell {
    
    var viewModel: CommentCellViewModel!
    
    let disposeBag = DisposeBag()

    let stackView = UIStackView()
    let nicknameLabel = UILabel()
    let buttonStackView = UIStackView()
    let editButton = UIButton()
    let deleteButton = UIButton()
    let contentsTextView = UITextView()
    let dateLabel = UILabel()
    
    func bind() {
        
        viewModel.data
            .map { $0.nickname }
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { $0.contents }
            .bind(to: contentsTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .map { self.dateFormat(with: $0.created) }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.data
            .withLatestFrom(UserManager.getInstance()) {
                if let id = $1?.id {
                    return $0.commenter != id
                } else  {
                    return true
                }
            }
            .bind(to: buttonStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    func setUp() {
        // attribute
        backgroundColor = UIColor(named: "mainColor")
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        
        [editButton, deleteButton].forEach { $0.titleLabel?.font = .systemFont(ofSize: 14) }
        
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(buttonStackView)
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        
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

        [stackView, contentsTextView, dateLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonStackView.widthAnchor.constraint(equalToConstant: 120),
            
            contentsTextView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentsTextView.bottomAnchor),
        
            bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
        ].forEach { $0.isActive = true }
    }
    
    private func dateFormat(with: String) -> String {
        return String(with.split(separator: "T")[0])
    }
}
