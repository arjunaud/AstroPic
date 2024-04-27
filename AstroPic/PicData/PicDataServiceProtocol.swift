//
//  File.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

enum PicDataServiceError: Error {
    case serverError(Int)
    case networkError(Error)
    case invalidResponse
    case dataFetchError
    case decodingError
    case invalidInput
}

protocol PicDataServiceProtocol {
    func fetchPics(startDate: Date, endDate: Date, completion: @escaping (Result<[Pic], PicDataServiceError>) -> Void)
}
