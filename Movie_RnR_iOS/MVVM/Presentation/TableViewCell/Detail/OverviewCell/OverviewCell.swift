//
//  OverViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift

class OverviewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    var viewModel: OverviewCellViewModel!
    
    let textView = UITextView()
    
    func bind() {
        viewModel.overview
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setUp() {
        backgroundColor = UIColor(named: "mainColor")
        textView.font = UIFont(name: "CarterOne", size: 15)
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "mainColor")
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heightAnchor.constraint(equalTo: textView.heightAnchor)
        ].forEach{ $0.isActive = true }
        
    }
}
