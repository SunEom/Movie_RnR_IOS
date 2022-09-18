//
//  TopStackViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift

class BottomStackViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    var viewModel: BottomStackViewCellViewModel! 
    
    let stackView = UIStackView()
    let dateLabel = UILabel()
    let nicknameButton = UIButton()
    
    func cellInit() {
        bind()
        setUp()
    }
    
    private func bind() {
        viewModel.date
            .map(dateFormat)
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .bind(to: nicknameButton.rx.title())
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = ProfileFactory().getInstance(userID: self.viewModel.writerID)
                self.viewModel.parentViewController.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        backgroundColor = UIColor(named: "mainColor")
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(nicknameButton)
        
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: "CarterOne", size: 12)
    
        nicknameButton.setTitleColor(.black, for: .normal)
        nicknameButton.titleLabel?.font = UIFont(name: "CarterOne", size: 12)
        nicknameButton.backgroundColor = .white
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ].forEach{ $0.isActive = true}
    }
    
    private func dateFormat(with: String?) -> String {
        guard let with = with else {
            return ""
        }
        
        return String(with.split(separator: "T")[0])

    }
}

