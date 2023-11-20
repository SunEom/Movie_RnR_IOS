//
//  TitleCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift
import SnapKit

class TitleCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "mainColor")
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CarterOne", size: 20)
        return label
    }()
    
    private var viewModel: TitleCellViewModel!
    
    func setUp(viewModel: TitleCellViewModel) {
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        titleLabel.text = viewModel.title
    }
    
    
    private func attribute() {
        contentView.backgroundColor = UIColor(named: "mainColor")
    }
    
    private func layout(){
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
