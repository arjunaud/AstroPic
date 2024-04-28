//
//  PicCellTableViewCell.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import UIKit
import Kingfisher


/// Class for represnting each Picture cell in Picture List
class PicListViewCell: UITableViewCell {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var picImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.picImageView.heightAnchor.constraint(equalTo: self.picImageView.widthAnchor, multiplier: 3.0/4.0).isActive = true
    }
    
    /// Configures the cell using PicCellViewModel
    /// - Parameter viewModel: PicCellViewModel which provides data for the view
    func configure(viewModel: PicCellViewModel) {
        self.infoLabel.text = viewModel.date + " : " + viewModel.title
        self.picImageView.kf.indicatorType = .activity
        self.picImageView.kf.setImage(with: viewModel.url)
    }

}
