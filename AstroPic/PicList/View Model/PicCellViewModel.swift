//
//  AstroPicCellViewModel.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

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
    
    func picTapped() {
        guard let router = self.router else { return }
        router.showPicDetails(pic: self.pic)
    }
}
