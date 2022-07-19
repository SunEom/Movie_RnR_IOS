//
//  CommentTableViewCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentsTextView.textContainer.lineFragmentPadding = 0
        contentsTextView.textContainerInset = .zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
