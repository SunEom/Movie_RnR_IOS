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
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .bottomHalf)
        presenter.keyboardTranslationType = .moveUp
        presenter.roundCorners = true
        presenter.cornerRadius = 20
        return presenter
    }()
    
    var viewModel: CommentCellViewModel!
    
    let disposeBag = DisposeBag()

    let stackView = UIStackView()
    let nicknameLabel = UILabel()
    let buttonStackView = UIStackView()
    let editButton = UIButton()
    let deleteButton = UIButton()
    
    let contentsTextView = UITextView()
    let dateLabel = UILabel()
    
    func cellInit() {
        setUp()
        bind()
    }
    
    private func bind() {
        
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
        
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "주의", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.viewModel.deleteRequest.onNext(Void())
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.viewModel.parentViewController.present(alert, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.data)
            .subscribe(onNext: {
                let vc = CommentEditViewFactory().getInstance(comment: $0)
                self.viewModel.parentViewController.customPresentViewController(self.presenter, viewController: vc, animated: true, completion: nil)
            })
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
    
    private func setUp() {
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
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonStackView.widthAnchor.constraint(equalToConstant: 120),
            
            contentsTextView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentsTextView.bottomAnchor),
        
            contentView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
        ].forEach { $0.isActive = true }
    }
    
    private func dateFormat(with: String) -> String {
        return String(with.split(separator: "T")[0])
    }
}
