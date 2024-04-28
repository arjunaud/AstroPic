//
//  AstroPicDataService.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

class PicDataService: PicDataServiceProtocol {
    private struct PicResponseItem : Decodable {
        enum CodingKeys: String, CodingKey {
            case title, explanation, date, url, hdurl, thumbNailURL = "thumbnail_url", mediaType = "media_type"
        }
        
        let title: String?
        let explanation: String?
        let date: Date?
        let url: URL?
        let hdurl: URL?
        let mediaType: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try? container.decodeIfPresent(String.self, forKey: .title)
            self.explanation = try? container.decodeIfPresent(String.self, forKey: .explanation)
            self.date = try? container.decodeIfPresent(Date.self, forKey: .date)
            
            self.mediaType = try? container.decodeIfPresent(String.self, forKey: .mediaType)
            
            if let urlString = try? container.decodeIfPresent(String.self, forKey: .thumbNailURL) {
                self.url = URL(string: urlString)
            } else if let urlString = try? container.decodeIfPresent(String.self, forKey: .url) {
                self.url = URL(string: urlString)
            } else {
                self.url = nil
            }
            
            if let urlString = try? container.decodeIfPresent(String.self, forKey: .hdurl) {
                self.hdurl = URL(string: urlString)
            } else if let urlString = try? container.decodeIfPresent(String.self, forKey: .url) {
                self.hdurl = URL(string: urlString)
            } else {
                self.hdurl = nil
            }
        }
    }

    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private struct EndPointConstants {
        static let apiKey = "kcMytUt6akizzOA3nonoCdsc3CwfR2u6FkK82af0"
        static let host = "api.nasa.gov"
        static let path = "/planetary/apod"
    }
    
    private static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
        
    func fetchPics(startDate: Date, endDate: Date, completion: @escaping (Result<[Pic], PicDataServiceError>) -> Void) {
    
        let apiKey = URLQueryItem(name: "api_key" , value: EndPointConstants.apiKey)
        
        let startDateItem = URLQueryItem(name: "start_date", value: String(format: Self.dateFormater.string(from: startDate)))

        let endDateItem = URLQueryItem(name: "end_date", value: String(format: Self.dateFormater.string(from: endDate)))
        
        let thumbsItem = URLQueryItem(name: "thumbs", value: "True")
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = EndPointConstants.host
        urlComponents.path = EndPointConstants.path
        urlComponents.queryItems = [apiKey, startDateItem, endDateItem, thumbsItem]
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidInput))
            return
        }
        
        let request = URLRequest(url: url, timeoutInterval: 30)
        
        let dataTask = self.urlSession.dataTask(with: request, completionHandler: { (data, response, responseError) -> Void in
            guard responseError == nil else {
                completion(.failure(.networkError(responseError!)))
                return
            }
            
            guard  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataFetchError))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(Self.dateFormater)
            do {
                let picResponseItems: [PicResponseItem] = try decoder.decode([PicResponseItem].self, from: data)
                let pics: [Pic] = picResponseItems.map {
                    Pic(title: $0.title, explanation: $0.explanation, date: $0.date, url: $0.url, hdurl: $0.hdurl, isVideo: $0.mediaType == "video")
                }
                completion(.success(pics))
             }
             catch  {
                 print(error)
                 completion(.failure(.decodingError))
             }
            
        })
        dataTask.resume()
    }
}
