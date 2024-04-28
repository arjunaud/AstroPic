//
//  PicDetailViewModel.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import Foundation

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
    
    var picExplanation: String? {
        return pic.explanation ?? "None"
    }
    
    var picURL: URL? {
        return pic.isVideo ? pic.url : (pic.hdurl ?? pic.url)
    }
    
    func viewDidLoad() {
        guard let delegate = self.delegate else { return }
        delegate.reloadUI()
    }
}
