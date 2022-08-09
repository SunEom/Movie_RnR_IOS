//
//  TopStackViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit

class TopStackViewCell: UITableViewCell {
    
    let stackView = UIStackView()
    let genresLabel = UILabel()
    let ratesLabel = UILabel()
    
    func setUp(genres: String, rates: Double) {
        backgroundColor = UIColor(named: "mainColor")
        
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(ratesLabel)
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        genresLabel.text = genres
        genresLabel.textColor = .black
        genresLabel.font = UIFont(name: "CarterOne", size: 13)
        
        ratesLabel.text = "★ \(rates) / 10"
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

