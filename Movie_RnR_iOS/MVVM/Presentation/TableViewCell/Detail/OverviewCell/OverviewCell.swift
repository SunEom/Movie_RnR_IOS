//
//  OverViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit

class OverviewCell: UITableViewCell {
    let textView = UITextView()
    
    func setup(overview: String) {
        backgroundColor = UIColor(named: "mainColor")
        
        textView.text = overview
        textView.font = UIFont(name: "CarterOne", size: 15)
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "mainColor")
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            textView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalTo: textView.heightAnchor)
        ].forEach{ $0.isActive = true }
        
        
    }
}
