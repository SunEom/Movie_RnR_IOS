//
//  TopStackViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift

class TopStackViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var viewModel: TopStackViewCellViewModel!
    
    let stackView = UIStackView()
    let genresLabel = UILabel()
    let ratesLabel = UILabel()
    
    func bind() {
        viewModel.genres
            .bind(to: genresLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.rates
            .map { "★ \($0 ?? "0") / 10"}
            .bind(to: ratesLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setUp() {
        backgroundColor = UIColor(named: "mainColor")
        
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(ratesLabel)
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        genresLabel.textColor = .black
        genresLabel.font = UIFont(name: "CarterOne", size: 13)
    
        ratesLabel.textAlignment = .right
        ratesLabel.textColor = .black
        ratesLabel.font = UIFont(name: "CarterOne", size: 13)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ].forEach{ $0.isActive = true}
    }
    
    
}

