//
//  AstroPicListViewRouter.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import UIKit

/// This is the router protocol which is to be used by the view model to show picture detail
protocol PicListViewRouterProtocol: AnyObject {
    
    /// Shows pic details screen for a given pic
    /// - Parameter pic: Pic whose detail is to be shown
    func showPicDetails(pic: Pic)
}


/// Class which provides the implementation of PicListViewRouterProtocol
class PicListViewRouter: Router {
    
    private weak var window: UIWindow?
    private weak var navigationVC: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }
    
    func build() -> UIViewController {
        let picListVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "PicListViewController") as! PicListViewController
        let navigationVC = UINavigationController(rootViewController: picListVC)
        let picListVM = PicListViewModel(service: PicDataService(), delegate: picListVC, router: self)
        picListVC.viewModel = picListVM
        self.navigationVC = navigationVC
        return navigationVC
    }
    
    func start() {
        guard let window = self.window else { return }
        window.rootViewController = build()
    }
}

extension PicListViewRouter: PicListViewRouterProtocol {
    func showPicDetails(pic: Pic) {
        guard let navigationVC = self.navigationVC else {
            return
        }
        let picDetailRouter = PicListDetailRouter(pic: pic, navigationVC: navigationVC)
        picDetailRouter.start()
    }
}
