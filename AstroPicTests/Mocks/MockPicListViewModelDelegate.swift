//
//  MockPicListViewModelDelegate.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import Foundation
@testable import AstroPic

class MockPicListViewModelDelegate: PicListViewModelDelegateProtocol {
    
    var showingLoadingIndicator = false
    
    typealias MockShowLoadingIndicatorBlock = () -> Void
    typealias MockStopLoadingIndicatorBlock = () -> Void
    typealias MockReloadListBlock = () -> Void
    typealias MockShowErrorMessageBlock = (String, String) -> Void
    
    var mockShowLoadingIndicatorBlock: MockShowLoadingIndicatorBlock?
    var mockStopLoadingIndicatorBlock: MockStopLoadingIndicatorBlock?
    var mockReloadListBlock: MockReloadListBlock?
    var mockShowErrorMessageBlock: MockShowErrorMessageBlock?
    
    func showLoadingIndicator() {
        self.showingLoadingIndicator = true
        self.mockShowLoadingIndicatorBlock?()
    }
    
    func stopLoadingIndicator() {
        self.showingLoadingIndicator = false
        self.mockStopLoadingIndicatorBlock?()
    }
    
    func reloadList() {
        self.mockReloadListBlock?()
    }
    
    func showErrorMessage(title: String, message: String) {
        self.mockShowErrorMessageBlock?(title, message)
    }
}
