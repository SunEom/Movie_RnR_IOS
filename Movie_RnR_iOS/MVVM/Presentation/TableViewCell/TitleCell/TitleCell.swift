//
//  TitleCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift

class TitleCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let titleLabel = UILabel()
    
    func bind(_ viewModel: TitleCellViewModel) {
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setUp() {
        contentView.backgroundColor = UIColor(named: "mainColor")
        titleLabel.backgroundColor = UIColor(named: "mainColor")
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "CarterOne", size: 20)
        
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ].forEach{ $0.isActive = true}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
}
