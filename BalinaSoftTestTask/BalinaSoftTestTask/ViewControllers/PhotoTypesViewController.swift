//
//  ViewController.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit

class PhotoTypesViewController: UIViewController {
    var photoTypesModel = PhotoTypesModel()
    var isLoading = false
    var pageNumb = 0
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        photoTypesModel.getPhotoTypes(page: pageNumb.description) { [weak self] error in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: photoTypesModel.photoCellIdentifier, bundle: nil), forCellReuseIdentifier: photoTypesModel.photoCellIdentifier)
        tableView.register(UINib(nibName: photoTypesModel.loadingCellIndentifier, bundle: nil), forCellReuseIdentifier: photoTypesModel.loadingCellIndentifier)
    }
    
    func loadMoreData() {
        if !self.isLoading && pageNumb <= photoTypesModel.response?.totalPages ?? 7 {
            self.isLoading = true
            pageNumb += 1
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                self.photoTypesModel.getPhotoTypes(page: self.pageNumb.description) { [weak self] error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension PhotoTypesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photoTypesModel.content.count - 20, !isLoading {
            loadMoreData()
        }
    }
}

extension PhotoTypesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: photoTypesModel.photoCellIdentifier, for: indexPath) as? PhotoTypeCell else {
                preconditionFailure("Could not cast value of type 'UITableViewCell' to PhotoTypeCell")
            }
            let content = photoTypesModel.content[indexPath.row]
            cell.configureLable(with: content)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: photoTypesModel.loadingCellIndentifier, for: indexPath) as? LoadingCell else {
                preconditionFailure("Could not cast value of type 'UITableViewCell' to LoadingCell")
            }
            if isLoading {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return photoTypesModel.calculateRowHeight(from: tableView.frame.size.height)
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return photoTypesModel.content.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}


