//
//  ViewController.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import UIKit

class PicListViewController: UIViewController {
    
    var viewModel: PicListViewModel!
    
    @IBOutlet weak var picListView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPicsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        self.navigationItem.title = "Picture of the Days"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshButtonTap))

        self.navigationItem.rightBarButtonItems = [refreshButton]
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        navigationController?.navigationBar.standardAppearance = appearance;
//        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        self.picListView.estimatedRowHeight = 300
        self.picListView.rowHeight = UITableView.automaticDimension
    }
    
    @objc private func onRefreshButtonTap () {
        self.viewModel.refresh()
    }
}

extension PicListViewController: PicListViewModelDelegateProtocol {
    func showLoadingIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    func reloadList() {
        self.picListView.reloadData()
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showNoPicsLabel(text: String) {
        self.noPicsLabel.text = text
        self.noPicsLabel.isHidden = false
    }
    
    func hideNoPicsLabel() {
        self.noPicsLabel.isHidden = true
    }
}
    
extension PicListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.picCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let picCell = tableView.dequeueReusableCell(withIdentifier: "PicListViewCell", for: indexPath) as! PicListViewCell
        picCell.configure(viewModel: self.viewModel.picCellModelForRow(row: indexPath.row))
        return picCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.picCellModelForRow(row: indexPath.row).picTapped()
    }
}
