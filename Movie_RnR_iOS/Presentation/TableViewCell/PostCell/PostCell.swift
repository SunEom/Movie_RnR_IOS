//
//  PostCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit

class PostCell: UITableViewCell {
    private var viewModel: PostCellViewModel!

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainColor")
        return view
    }()
    
    private let postImageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let genreLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 5
        return label
    }()
    
    private let bottomStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    func setUp(viewModel: PostCellViewModel){
        self.viewModel = viewModel
        
        bind()
        attribute()
        layout()
    }

    
    func bind() {
        postImageView.image = UIImage(named: "postImage1")
        
        titleLabel.text = viewModel.title
        genreLabel.text = viewModel.genres
        overviewLabel.text = viewModel.overview
        rateLabel.text = "★ \(viewModel.rates)"
        commentLabel.text = "💬 \(viewModel.commnetNum)"
        
        layout()
        attribute()
        shadowConfig()
    }
    
    private func attribute() {
        backgroundColor = UIColor(named: "mainColor")
    }
    
    private func layout() {
        
        [rateLabel, commentLabel].forEach {
            bottomStackview.addArrangedSubview($0)
        }
        
        contentView.addSubview(topView)
        
        [postImageView,titleLabel,genreLabel,overviewLabel, bottomStackview].forEach {
            topView.addSubview($0)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.bottom.equalTo(contentView).offset(-20)
            $0.width.equalTo(320)
            $0.centerX.equalTo(contentView)
        }
        
        postImageView.snp.makeConstraints {
            $0.width.equalTo(290)
            $0.height.equalTo(145)
            $0.top.equalTo(topView).offset(20)
            $0.centerX.equalTo(topView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(postImageView)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(postImageView)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(postImageView)
            $0.bottom.equalTo(bottomStackview.snp.top)
        }
        
        bottomStackview.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(postImageView)
            $0.bottom.equalTo(topView).offset(-15)
        }
    }
    
    private func shadowConfig() {
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 10
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowPath = nil
        topView.layer.cornerRadius = 5
    }
}
