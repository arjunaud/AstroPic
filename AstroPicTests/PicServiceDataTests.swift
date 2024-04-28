//
//  PicServiceDataTests.swift
//  AstroPicTests
//
//  Created by arjuna on 27/04/24.
//

import XCTest
@testable import AstroPic

final class PicServiceDataTests: XCTestCase {

    private var service: PicDataService!
    private static let expectationTimeout = 30.0
    
    private static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var startDate: Date!
    private var endDate: Date!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        self.startDate = Self.dateFormater.date(from: "2024-04-01")!
        self.endDate = Self.dateFormater.date(from: "2024-04-02")!
        self.service = PicDataService(urlSession: urlSession)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = nil
        self.service = nil
    }

    func testSerivceReturnsPicsWhenAPICallIsSuccess() throws {
        //Given
        let response =
            """
              [
                {
                  "copyright": "copyright 1",
                  "date": "2024-04-01",
                  "explanation": "Pic1 explanatation",
                  "hdurl": "https://host.com/pic1-hdurl",
                  "media_type": "image",
                  "service_version": "v1",
                  "title": "Pic1 title",
                  "url": "https://host.com/pic1-url"
                },
                {
                  "copyright": "copyright 2",
                  "date": "2024-04-02",
                  "explanation": "Pic2 explanatation",
                  "media_type": "video",
                  "service_version": "v1",
                  "title": "Pic2 title",
                  "url": "https://host.com/vid2-url",
                  "thumbnail_url": "https://host.com/pic2-thumb-url"
                }
              ]

              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            self.validatePicURL(url: request.url)
            let response = HTTPURLResponse(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=kcMytUt6akizzOA3nonoCdsc3CwfR2u6FkK82af0&start_date=2024-04-01&end_date=2024-04-02&thumbs=True")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        
        let expectation = expectation(description: "It should recieve Pics")
                
        //When
        self.service.fetchPics(startDate: self.startDate, endDate: self.endDate) { result in
            switch result {
            case .success(let pics):
                let expectedPics = [
                    Pic(title: "Pic1 title", explanation: "Pic1 explanatation", date: self.startDate, url: URL(string: "https://host.com/pic1-url"), hdurl: URL(string: "https://host.com/pic1-hdurl"), isVideoGeneratedPic: false),
                    Pic(title: "Pic2 title", explanation: "Pic2 explanatation", date: self.endDate, url: URL(string: "https://host.com/pic2-thumb-url"), hdurl: URL(string: "https://host.com/vid2-url"), isVideoGeneratedPic: true)
                ]
                XCTAssertEqual(pics, expectedPics)
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Error is not expcted = \(err)")
            }
        }
        
        //Then
        wait(for: [expectation], timeout: Self.expectationTimeout)
    }
    
    func testSerivceReturnsErrorWhenAPICallReturnsInvalidStatusCode() throws {
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            self.validatePicURL(url: request.url)
            let response = HTTPURLResponse(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=kcMytUt6akizzOA3nonoCdsc3CwfR2u6FkK82af0&start_date=2024-04-01&end_date=2024-04-02")!,
                                           statusCode: 400,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        
        let expectation = expectation(description: "It should recieve invalid repsonse error")
                
        self.service.fetchPics(startDate: self.startDate, endDate: self.endDate) { result in
            switch result {
            case .success(let pics):
                XCTFail("Success is not expcted in this case = \(pics)")
            case .failure(let err):
                guard case .serverError(400) = err else {
                    XCTFail("Got different error than expected = \(err)")
                    return
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: Self.expectationTimeout)
    }

    func testSerivceReturnsErrorWhenAPICallReturnsError() throws {
        let expectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
        
        MockURLProtocol.error = expectedError
        
        let expectation = expectation(description: "It should recieve invalid repsonse error")
                
        self.service.fetchPics(startDate: self.startDate, endDate: self.endDate) { result in
            switch result {
            case .success(let pics):
                XCTFail("Success is not expcted in this case = \(pics)")
            case .failure(let err):
                guard case .networkError(let err) = err else {
                    XCTFail("Got different error than expected = \(err)")
                    return
                }
                XCTAssertEqual((err as NSError).code, expectedError.code)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: Self.expectationTimeout)
    }
    
    private func validatePicURL(url: URL?) {
        guard let url else {
            XCTFail("Nil Pic URL")
            return
        }
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            XCTFail("Inavlid Pic URL")
            return
        }
        
        XCTAssertEqual(urlComponents.scheme, "https")
        XCTAssertEqual(urlComponents.path, "/planetary/apod")
        XCTAssertEqual(urlComponents.host, "api.nasa.gov")
        XCTAssertEqual(urlComponents.queryItems?.count, 4)
        guard let apiKeyQueryItem = urlComponents.queryItems?[0] else {
            XCTFail("Inavlid API Key component")
            return
        }
        XCTAssertEqual(apiKeyQueryItem.name, "api_key")
        XCTAssertEqual(apiKeyQueryItem.value, "kcMytUt6akizzOA3nonoCdsc3CwfR2u6FkK82af0")

        
        guard let startDateQueryItem = urlComponents.queryItems?[1] else {
            XCTFail("Inavlid start date component")
            return
        }
        XCTAssertEqual(startDateQueryItem.name, "start_date")
        XCTAssertEqual(startDateQueryItem.value, Self.dateFormater.string(from: self.startDate))
        
        guard let endDateQueryItem = urlComponents.queryItems?[2] else {
            XCTFail("Inavlid end date component")
            return
        }
        XCTAssertEqual(endDateQueryItem.name, "end_date")
        XCTAssertEqual(endDateQueryItem.value, Self.dateFormater.string(from: self.endDate))
        
        guard let thumbsQueryItem = urlComponents.queryItems?[3] else {
            XCTFail("Inavlid Thumbs  component")
            return
        }
        XCTAssertEqual(thumbsQueryItem.name, "thumbs")
        XCTAssertEqual(thumbsQueryItem.value, "True")

    }
    
}
