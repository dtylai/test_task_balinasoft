//
//  ViewController.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit

class PhotoTypesViewController: UIViewController {
    var photoTypesModel = PhotoTypesModel()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        photoTypesModel.getPhotoTypes(page: photoTypesModel.getPageNumb().description) { [weak self] error in
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
        if !photoTypesModel.getIsLoading() && photoTypesModel.getPageNumb() <= photoTypesModel.response?.totalPages ?? 7 {
            photoTypesModel.setIsLoading(isLoading: true)
            photoTypesModel.setPageNumb(pageNumb: photoTypesModel.getPageNumb()+1)
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                self.photoTypesModel.getPhotoTypes(page: self.photoTypesModel.getPageNumb().description) { [weak self] error in
                    DispatchQueue.main.async {
                        self?.photoTypesModel.setIsLoading(isLoading: false)
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension PhotoTypesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        photoTypesModel.setIdCell(idCell: indexPath.item)
        let imagePickerController = UIImagePickerController()
        
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photoTypesModel.content.count - 1, !photoTypesModel.getIsLoading() {
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
            if photoTypesModel.getIsLoading() {
                cell.startActivity()
            } else {
                cell.stopActivity()
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

extension PhotoTypesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            photoTypesModel.uploadPhoto(typeId: photoTypesModel.getIdCell(), name: "Dmitry Tulay", image: image) { error in
            }
        }
        dismiss(animated: true)
    }
}

