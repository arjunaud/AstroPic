//
//  PicDetailViewModel.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import Foundation

/// Protocol to be implemented by  view using PicDetailViewModel
protocol PicDetailViewModelDelegate: AnyObject {
    func reloadUI()
}

class PicDetailViewModel {
    private let pic: Pic
    private weak var delegate: PicDetailViewModelDelegate?
    
    init(pic: Pic, delegate: PicDetailViewModelDelegate) {
        self.pic = pic
        self.delegate = delegate
    }
    
    ///  Returns pic description or explanation
    var picExplanation: String? {
        return pic.explanation ?? "None"
    }
    
    /// Returns thumbnail url in case of video or hd pic url in case of image
    var picURL: URL? {
        return pic.isVideo ? pic.url : (pic.hdurl ?? pic.url)
    }
    
    /// Handles view loaded event of the detail screen
    func viewDidLoad() {
        guard let delegate = self.delegate else { return }
        delegate.reloadUI()
    }
}
