//
//  MockPicDetailVewModelDelegate.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import Foundation
@testable import AstroPic

class MockPicDetailViewModelDelegate: PicDetailViewModelDelegate {
    
    typealias MockReloadUIBlock =  () -> Void
    var mockReloadUIBlock: MockReloadUIBlock?

    
    func reloadUI() {
        self.mockReloadUIBlock?()
    }

}
