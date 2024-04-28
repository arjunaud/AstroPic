//
//  MockPicListViewRouter.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import Foundation
@testable import AstroPic

class MockPicListViewRouter: PicListViewRouterProtocol {
    typealias MockShowPicDetailsBlock = (Pic) -> Void
    var  mockShowPicDetailsBlock: MockShowPicDetailsBlock?
    
    func showPicDetails(pic: Pic) {
        self.mockShowPicDetailsBlock?(pic)
    }
    
}
