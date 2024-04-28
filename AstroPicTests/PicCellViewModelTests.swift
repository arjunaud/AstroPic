//
//  PicCellViewModeTests.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import XCTest
@testable import AstroPic


final class PicCellViewModelTests: XCTestCase {
    
    private var viewModel: PicCellViewModel!
    private var router: MockPicListViewRouter!
    private static let expectationTimeout = 30.0
    
    override func setUpWithError() throws {
        self.router = MockPicListViewRouter()
    }

    func testPicCellModeReturnsNoneForMissingTitle() throws {
        let pic = Pic(title: nil, explanation: nil, date: Date(), url: nil, hdurl: nil, isVideoGeneratedPic: false)
        self.viewModel = PicCellViewModel(pic: pic, router: self.router)
        XCTAssertEqual(self.viewModel.title, "None")
        
    }
    
    func testPicCellModelFormatsDataInTheRequiredFormat() throws {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        dateComponent.year = 2024
        dateComponent.month = 4
        let date = Calendar.current.date(from: dateComponent)

        let pic = Pic(title: "title", explanation: "explanation", date: date, url: URL(string: "https://host.com/pic-url")!, hdurl: URL(string: "https://host.com/pic-hdurl")!, isVideoGeneratedPic: false)
        self.viewModel = PicCellViewModel(pic: pic, router: self.router)
        XCTAssertEqual(self.viewModel.title, pic.title)
        XCTAssertEqual(self.viewModel.date, "2024-04-01")
        XCTAssertEqual(self.viewModel.url, pic.url)
    }
    
    func testPicCellModelCallsRouterMethodOnTapped() throws {
        //Given
        let expectedPic = Pic(title: nil, explanation: nil, date: Date(), url: nil, hdurl: nil, isVideoGeneratedPic: false)
        self.viewModel = PicCellViewModel(pic: expectedPic, router: self.router)
        
        let routerExpectation = expectation(description: "routerExpectation")
        self.router.mockShowPicDetailsBlock = { [weak self] pic in
            XCTAssertEqual(pic, expectedPic)
            routerExpectation.fulfill()
        }
        
        //When
        self.viewModel.picTapped()
        
        //Then
        wait(for: [routerExpectation], timeout: Self.expectationTimeout)
    }
}
