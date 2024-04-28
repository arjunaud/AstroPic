//
//  PicDetailViewController.swift
//  AstroPic
//
//  Created by arjuna on 27/04/24.
//

import UIKit
import Kingfisher

class PicDetailViewController: UIViewController {
    
    var viewModel: PicDetailViewModel!

    @IBOutlet weak var explanationView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PicDetailViewController: PicDetailViewModelDelegate {
    func reloadUI() {
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: self.viewModel.picURL)
        self.explanationView.text = self.viewModel.picExplanation
    }
}

extension PicDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
