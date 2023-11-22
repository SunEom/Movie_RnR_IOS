//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//
import UIKit
import RxSwift
import Presentr

class CommentCellViewController: UITableViewCell {
    
    private var viewModel: CommentCellViewModel!
    
    private let disposeBag = DisposeBag()

    private let stackView = UIStackView()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
//    private let buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.spacing = 10
//        return stackView
//    }()
//    
//    private let editButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
//    
//    private let deleteButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .black
//        button.setImage(UIImage(systemName: "xmark"), for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        return button
//    }()
    
    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 13)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "mainColor")
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    

    
    func cellInit(viewModel: CommentCellViewModel) {
        self.viewModel = viewModel
        setUp()
        bind()
    }
    
    private func bind() {
        
        let output = viewModel.transform()
        
        nicknameLabel.text = output.comment.nickname
        contentsTextView.text = output.comment.contents
        dateLabel.text = dateFormat(with: output.comment.created)

    }
    
    private func setUp() {
        // attribute
        backgroundColor = UIColor(named: "mainColor")
    
        
//        [editButton, deleteButton].forEach { $0.titleLabel?.font = .systemFont(ofSize: 14) }
                
        stackView.addArrangedSubview(nicknameLabel)
//        stackView.addArrangedSubview(buttonStackView)
        
//        buttonStackView.addArrangedSubview(editButton)
//        buttonStackView.addArrangedSubview(deleteButton)
    
        // layout
        [stackView, contentsTextView, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.trailing.equalTo(contentView)
        }
        
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentsTextView.snp.bottom)
            $0.bottom.equalTo(contentView).offset(-15)
        }
    }
    
    private func dateFormat(with: String) -> String {
        return String(with.split(separator: "T")[0])
    }
}
