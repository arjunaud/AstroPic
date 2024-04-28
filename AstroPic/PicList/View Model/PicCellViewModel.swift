//
//  AstroPicCellViewModel.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

/// View model for the cell displayed in pic list
class PicCellViewModel {
    private let pic: Pic
    private weak var router: PicListViewRouterProtocol?
    private static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(pic: Pic, router: PicListViewRouterProtocol) {
        self.pic = pic
        self.router = router
        self.title = pic.title ?? "None"
        var date = "None"
        if  let picDate = pic.date {
            date = Self.dateFormater.string(from: picDate)
        }
        self.date = date
        self.url = pic.url ?? pic.hdurl
    }
    
    let title: String
    let date: String
    let url: URL?
    
    /// Handles tap on pic cell and shows pic details
    func picTapped() {
        guard let router = self.router else { return }
        router.showPicDetails(pic: self.pic)
    }
}
