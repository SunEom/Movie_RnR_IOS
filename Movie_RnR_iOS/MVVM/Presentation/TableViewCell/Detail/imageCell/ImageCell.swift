//
//  ImageCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit

class ImageCell: UITableViewCell {
    
    let postImageView = UIImageView()
    
    func cellInit(imageName: String) {
        setUp(imageName: imageName)
    }
    
    private func setUp(imageName: String) {
        
        backgroundColor = UIColor(named: "mainColor")
        
        postImageView.image = UIImage(named: "postImage1")
        
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(postImageView)
        
        [
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width)/2 + 100),
            postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            postImageView.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width-30)*0.65),

            postImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ].forEach{ $0.isActive = true }
        
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
