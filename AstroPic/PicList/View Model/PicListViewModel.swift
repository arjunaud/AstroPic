//
//  AstroPicListViewModel.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

/// Protocol to be implemented by the view  using PicListViewModel
protocol PicListViewModelDelegateProtocol: AnyObject {
    
    /// Tell the the view to show loading indicator
    func showLoadingIndicator()
    
    /// Tells the view to stop loading indicator
    func stopLoadingIndicator()
    
    /// Tells the view to reload the Pic List
    func reloadList()
    
    // Tells the view to display error message
    func showErrorMessage(title:String, message: String)
}


class PicListViewModel {
    
    private weak var delegate: PicListViewModelDelegateProtocol?
    private let router: PicListViewRouterProtocol
    private let service: PicDataServiceProtocol
    
    private static let daysToFetch = 6

    private var isLoadingServiceData = false {
        didSet {
            if self.isLoadingServiceData {
                self.delegate?.showLoadingIndicator()
            } else {
                self.delegate?.stopLoadingIndicator()
            }
        }
    }
    
    init(service: PicDataServiceProtocol, 
         delegate: PicListViewModelDelegateProtocol,
         router: PicListViewRouterProtocol) {
        self.service = service
        self.delegate = delegate
        self.router = router
    }
    
    private var picCellViewModels: [PicCellViewModel] = [] {
        didSet {
            self.delegate?.reloadList()
        }
    }
    
    /// Returns number of pictures
    var picCount: Int {
        return self.picCellViewModels.count
    }
    
    /// Returns PicCellViewModel for each row of Pcicture List View
    /// - Parameter row: Row Index
    /// - Returns: PicCellViewModel for each row of Pcicture List View
    func picCellModelForRow(row: Int) -> PicCellViewModel {
        return self.picCellViewModels[row]
    }

    
    /// Handles refresh button on the List screen. Just initiates the fetchnig of Pics
    func refresh() {
        self.fetchPics()
    }
    
    /// Handles viewDidLoad event of Pic List Screen
    func viewDidLoad() {
        self.refresh()
    }
    
    private func fetchPics() {
        self.isLoadingServiceData = true
        let endDate = Date()
        guard let startDate = Calendar.current.date(byAdding: .day, value: -Self.daysToFetch , to: endDate) else {
            self.isLoadingServiceData = false
            self.delegate?.showErrorMessage(title: "App Error", message: "Internal app error. Please tap on refresh")
            return
        }
        
        self.service.fetchPics(startDate: startDate, endDate: endDate) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingServiceData = false
                switch result {
                case .success(let pics):
                    self.updatePics(pics: pics)
                    if pics.isEmpty {
                        self.delegate?.showErrorMessage(title: "No Pics found", message: "No Pics were found. Please tap on refresh.")
                    }
                    break
                    
                case.failure(let picDataServiceError):
                    self.handlePicDataServiceError(error: picDataServiceError)
                    break
                }
            }
        }
    }
    
    private func updatePics(pics: [Pic]) {
        let picCellViewModels = pics.sorted(by: { pic1 , pic2 in
            (pic1.date ?? Date()) > (pic2.date ?? Date())
        }).map({ pic in
            return PicCellViewModel(pic: pic, router: self.router)
        })
        self.picCellViewModels = picCellViewModels
    }
    
    private func handlePicDataServiceError(error: PicDataServiceError) {
        switch error {
        case .serverError(_), .dataFetchError, .decodingError, .invalidResponse:
            self.delegate?.showErrorMessage(title: "Pic fetch error", message: "Pic fetch falied from server. Please tap on refresh after some time.")
            break
        case .networkError(_):
            self.delegate?.showErrorMessage(title: "Pic fetch error", message: "Unable to connect to server. Please troubleshoot your internet connection and tap on refresh.")
            break
        case .invalidInput:
            self.delegate?.showErrorMessage(title: "Pic fetch error", message: "Something went wrong in the app. Please tap on refresh again.")
            break
        }
    }

}
