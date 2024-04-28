//
//  File.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

/// Error type dedicated to PicDataServiceProtocol
enum PicDataServiceError: Error {
    case serverError(Int)
    case networkError(Error)
    case invalidResponse
    case dataFetchError
    case decodingError
    case invalidInput
}

/// This protocol should be implemented by data service implementation which returns Pic Models
protocol PicDataServiceProtocol {
    
    /// Fetches the Picture of the Days between the given start date and end date
    /// - Parameters:
    ///   - startDate: starting date from which the Picture is to be fetched
    ///   - endDate: end date till which  the Picture is to be fetched
    ///   - completion: Completion have array of pics or the error if it fails
    func fetchPics(startDate: Date, endDate: Date?, completion: @escaping (Result<[Pic], PicDataServiceError>) -> Void)
}
