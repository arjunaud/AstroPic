//
//  MockPicDataService.swift
//  AstroPicTests
//
//  Created by arjuna on 28/04/24.
//

import Foundation
@testable import AstroPic

class MockPicDataService: PicDataServiceProtocol {
    
    typealias MockFetchPicsBlock =  (Date, Date?, (Result<[Pic], PicDataServiceError>) -> Void) -> Void

    var mockFetchPicsBlock: MockFetchPicsBlock?

    
    func fetchPics(startDate: Date, endDate: Date?, completion: @escaping (Result<[Pic], PicDataServiceError>) -> Void) {
        self.mockFetchPicsBlock?(startDate, endDate, completion)
    }

}
