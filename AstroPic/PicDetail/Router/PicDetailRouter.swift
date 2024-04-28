//
//  PicDetailRouter.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import UIKit

class PicListDetailRouter: Router {
    
    private weak var navigationVC: UINavigationController?
    private let pic: Pic

    init(pic: Pic, navigationVC: UINavigationController?) {
        self.pic = pic
        self.navigationVC = navigationVC
    }
    
    func build() -> UIViewController {
        let picDetailVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "PicDetailViewController") as! PicDetailViewController
        let picDetailVM = PicDetailViewModel(pic: pic, delegate: picDetailVC)
        picDetailVC.viewModel = picDetailVM
        return picDetailVC
    }
    
    func start() {
        guard let navigationVC = self.navigationVC else { return }
        navigationVC.pushViewController(build(), animated: true)
    }
    
    func showPicDetails(pic: Pic) {
        guard let navigationVC = self.navigationVC else {
            return
        }
        navigationVC.pushViewController(UIViewController(), animated: true)
    }
    
}
