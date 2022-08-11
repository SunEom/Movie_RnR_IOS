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
    
    let stackView = UIStackView()
    let dateLabel = UILabel()
    let nicknameLabel = UILabel()
    
    func bind(_ viewModel: BottomStackViewCellViewModel) {
        viewModel.date
            .map(dateFormat)
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setUp() {
        backgroundColor = UIColor(named: "mainColor")
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(nicknameLabel)
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: "CarterOne", size: 12)
        
        nicknameLabel.textAlignment = .right
        nicknameLabel.textColor = .black
        nicknameLabel.font = UIFont(name: "CarterOne", size: 12)
        
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

