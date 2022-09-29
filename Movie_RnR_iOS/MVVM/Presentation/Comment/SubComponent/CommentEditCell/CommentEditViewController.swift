//
//  CommentEditViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/07.
//

import UIKit
import Presentr
import RxSwift

class CommentEditViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var viewModel: CommentEditViewModel!
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let saveButton = UIButton()
    let contentsTextView = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bind()
        attribute()
        layout()
        
    }
    
    private func bind() {
        
        contentsTextView.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.contents)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.editRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "댓글이 정상적으로 수정되었습니다.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.message ?? "", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default)
                    
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        titleLabel.text = "Edit Comment"
        titleLabel.font = UIFont(name: "CarterOne", size: 23)
        titleLabel.textColor = .black
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.backgroundColor = UIColor(named: "headerColor")
        saveButton.layer.cornerRadius = 5
        
        contentsTextView.backgroundColor = .white
        contentsTextView.textColor = .black
        contentsTextView.font = .systemFont(ofSize: 16)
        
        contentsTextView.text = viewModel.comment.contents
    }
    
    private func layout() {
    
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(saveButton)
        
        [stackView, contentsTextView]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            
            contentsTextView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            contentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            contentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            contentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ].forEach { $0.isActive = true }
    }
    
}
