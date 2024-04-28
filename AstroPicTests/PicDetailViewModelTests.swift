//
//  PicDetailViewModelTests.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import XCTest
@testable import AstroPic

final class PicDetailViewModelTests: XCTestCase {

    var viewModel : PicDetailViewModel!
    var viewModelDelegate: MockPicDetailViewModelDelegate!
    
    private static let expectationTimeout = 30.0
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModelDelegate = MockPicDetailViewModelDelegate()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPicDetailReturnsProperPicDetails () throws {
        //Given
        let pic = Pic(title: "title", explanation: "explanation", date: Date(), url: URL(string: "https://host.com/pic-url")!, hdurl: URL(string: "https://host.com/pic-hdurl")!, isVideo: false)
        
        let viewModelDelegateExpectation = expectation(description: "viewModelDelegateExpectation")
        self.viewModelDelegate.mockReloadUIBlock = { [weak self] in
            guard let self = self else { return }
            XCTAssertEqual(self.viewModel.picExplanation, pic.explanation)
            XCTAssertEqual(self.viewModel.picURL, pic.hdurl)
            viewModelDelegateExpectation.fulfill()
        }
        
        self.viewModel = PicDetailViewModel(pic: pic, delegate: self.viewModelDelegate)
        
        //When
        self.viewModel.viewDidLoad()
        
        //Then
        wait(for: [viewModelDelegateExpectation], timeout: Self.expectationTimeout)
    }
    
    func testPicDetailReturnsNoneExplanationWhenItIsNil () throws {
        //Given
        let pic = Pic(title: "title", explanation: nil, date: Date(), url: URL(string: "https://host.com/pic-url")!, hdurl: URL(string: "https://host.com/pic-hdurl")!, isVideo: false)
        
        let viewModelDelegateExpectation = expectation(description: "viewModelDelegateExpectation")
        self.viewModelDelegate.mockReloadUIBlock = { [weak self] in
            guard let self = self else { return }
            XCTAssertEqual(self.viewModel.picExplanation, "None")
            XCTAssertEqual(self.viewModel.picURL, pic.hdurl)
            viewModelDelegateExpectation.fulfill()
        }
        
        self.viewModel = PicDetailViewModel(pic: pic, delegate: self.viewModelDelegate)
        
        //When
        self.viewModel.viewDidLoad()
        
        //Then
        wait(for: [viewModelDelegateExpectation], timeout: Self.expectationTimeout)
    }
}
