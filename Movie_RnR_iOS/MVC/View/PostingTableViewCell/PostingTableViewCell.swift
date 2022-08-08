//
//  PostingTableViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/17.
//

import UIKit

class PostingTableViewCell: UITableViewCell {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var commentNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowConfig()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func shadowConfig() {
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 10
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowPath = nil
        topView.layer.cornerRadius = 5
    }
    
}
