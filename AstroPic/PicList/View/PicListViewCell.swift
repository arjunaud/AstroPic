//
//  PicCellTableViewCell.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import UIKit
import Kingfisher

class PicListViewCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var picImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.picImageView.heightAnchor.constraint(equalTo: self.picImageView.widthAnchor, multiplier: 3.0/4.0).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(viewModel: PicCellViewModel) {
        var date = AttributedString(viewModel.date)
        date.font = .footnote
        date.foregroundColor = .gray
        
        var title = AttributedString(viewModel.title)
        title.font = .title
        title.foregroundColor = .red
        self.infoLabel.attributedText = NSAttributedString(date + " : " + title)
        self.picImageView.kf.indicatorType = .activity
        self.picImageView.kf.setImage(with: viewModel.url)
    }

}
