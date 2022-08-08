//
//  PostCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit

class PostCell: UITableViewCell {

    let topView = UIView()
    let postImageView = UIImageView()
    let titleLabel = UILabel()
    let genreLabel = UILabel()
    let overviewLabel = UILabel()
    let bottomStackview = UIStackView()
    let rateLabel = UILabel()
    let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initialize with not available way")
    }

    
    func bind(_ viewModel: PostCellViewModel) {
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
        topView.backgroundColor = UIColor(named: "mainColor")
        
        [titleLabel, genreLabel, rateLabel, overviewLabel, commentLabel].forEach{
            $0.textColor = .black
            $0.font = UIFont(name: "CarterOne", size: 15)
        }
        
        overviewLabel.numberOfLines = 6
        
        titleLabel.textAlignment = .center
        
        bottomStackview.alignment = .fill
        bottomStackview.distribution = .fillEqually
        
        commentLabel.textAlignment = .right
        
    }
    
    private func layout() {
        
        bottomStackview.addArrangedSubview(rateLabel)
        bottomStackview.addArrangedSubview(commentLabel)
        
        [topView,postImageView,titleLabel,genreLabel,overviewLabel, bottomStackview].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            topView.widthAnchor.constraint(equalToConstant: 320),
            topView.heightAnchor.constraint(equalToConstant: 450),
            topView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            postImageView.widthAnchor.constraint(equalToConstant: 290),
            postImageView.heightAnchor.constraint(equalToConstant: 145),
            postImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            postImageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo:postImageView.trailingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            genreLabel.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            
            bottomStackview.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -15),
            bottomStackview.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            bottomStackview.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor)
        ].forEach{ $0.isActive = true }
        
    }
    
    private func shadowConfig() {
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 10
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowPath = nil
        topView.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
}
