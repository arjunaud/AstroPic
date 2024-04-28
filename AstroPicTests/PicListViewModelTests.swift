//
//  PicListViewModelTests.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import XCTest
@testable import AstroPic

final class PicListViewModelTests: XCTestCase {
    
    var viewModel: PicListViewModel!
    var dataService: MockPicDataService!
    var viewModelDelegate: MockPicListViewModelDelegate!
    var router: MockPicListViewRouter!
    
    private static let expectationTimeout = 30.0

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dataService = MockPicDataService()
        self.viewModelDelegate = MockPicListViewModelDelegate()
        self.router = MockPicListViewRouter()
        self.viewModel = PicListViewModel(service: self.dataService, delegate: self.viewModelDelegate, router: self.router)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewDidLoadUpdatesUISuccessfullyWhenDataServiceAPIReturnsValidData() throws {
        
        //Given
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let dataServiceExpectation = self.expectation(description: "dataServiceExpectation")
        let pics = [
            Pic(title: "Pic1 title", explanation: "Pic1 explanatation", date: today, url: URL(string: "https://host.com/pic1-url"), hdurl: URL(string: "https://host.com/pic1-hdurl"), isVideoGeneratedPic: false),
            Pic(title: "Pic2 title", explanation: "Pic2 explanatation", date: tomorrow, url: URL(string: "https://host.com/pic2-thumb-url"), hdurl: URL(string: "https://host.com/vid2-url"), isVideoGeneratedPic: true)
        ]

        self.dataService.mockFetchPicsBlock = {
            [weak self] (startDate, endDate, completion) in
            guard let self = self else { return }
            let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
            XCTAssertEqual(numberOfDays, 7)

            XCTAssertTrue(self.viewModelDelegate.showingLoadingIndicator)
            completion(.success(pics))
            dataServiceExpectation.fulfill()
        }
        
        let reloadListWithProperDataExpectation = self.expectation(description: "reloadListWithProperDataExpectation")
        self.viewModelDelegate.mockReloadListBlock = { [weak self] in
            guard let self = self else { return }
            XCTAssert(Thread.isMainThread)
            XCTAssertEqual(self.viewModel.picCount, 2)
            XCTAssertFalse(self.viewModelDelegate.showingLoadingIndicator)
            
            //Note: Checking if it is sorted based on latest date first and if the cell view model has proper value. Here Eg: have checked only title in the interest of time. Similary other properties are to be compared.
            XCTAssertEqual(self.viewModel.picCellModelForRow(row: 1).title,  pics[0].title)
            XCTAssertEqual(self.viewModel.picCellModelForRow(row: 0).title,  pics[1].title)
            reloadListWithProperDataExpectation.fulfill()
        }
        
        //When
        self.viewModel.viewDidLoad()
        
        //Then
        wait(for: [dataServiceExpectation, reloadListWithProperDataExpectation], timeout: Self.expectationTimeout)
    }

    //Note: Following is one example of checkig for one kind of error. Similar thing can be written for all the possible errors
    func testViewDidLoadDisplaysAppropriateErrorMessageWhenServiceReturnsNeworkError() throws {
        
        //Given
        let dataServiceExpectation = self.expectation(description: "dataServiceExpectation")

        self.dataService.mockFetchPicsBlock = {
            [weak self] (startDate, endDate, completion) in
            guard let self = self else { return }
            XCTAssertTrue(self.viewModelDelegate.showingLoadingIndicator)
            completion(.failure(.networkError(NSError())))
            dataServiceExpectation.fulfill()
        }
        
        let showErrorExpectation = self.expectation(description: "showErrorExpectation")
        
        self.viewModelDelegate.mockShowErrorMessageBlock = { (title, errorMessage) in
            XCTAssertEqual(title, "Pic fetch error")
            XCTAssertEqual(errorMessage, "Unable to connect to server. Please troubleshoot your internet connection and tap on refresh.")
            showErrorExpectation.fulfill()
            XCTAssertFalse(self.viewModelDelegate.showingLoadingIndicator)
        }
        
        //When
        self.viewModel.viewDidLoad()
        
        //Then
        wait(for: [dataServiceExpectation, showErrorExpectation], timeout: Self.expectationTimeout)
    }
  

}
