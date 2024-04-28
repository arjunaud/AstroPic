//
//  AstroPicListViewRouter.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import UIKit

protocol PicListViewRouterProtocol: AnyObject {
    func showPicDetails(pic: Pic)
}

class PicListViewRouter: Router, PicListViewRouterProtocol {
    
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
    
    func showPicDetails(pic: Pic) {
        guard let navigationVC = self.navigationVC else {
            return
        }
        let picDetailRouter = PicListDetailRouter(pic: pic, navigationVC: navigationVC)
        picDetailRouter.start()
    }
    
}
