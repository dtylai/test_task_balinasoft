//
//  PhotoTypesModel.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit
import Alamofire

class PhotoTypesModel {
    var photosNetworkManager: NetworkManagerProtocol
    private(set) var content = [Content]()
    private(set) var response: Response?
    private var idCell = 0
    private var isLoading = false
    private var pageNumb = 0
    
    let photoCellIdentifier: String = String(describing: PhotoTypeCell.self)
    let loadingCellIndentifier: String = String(describing: LoadingCell.self)
    let urlPhotoRequest = URLRequestProvider(
        baseURL: "http://junior.balinasoft.com",
        path:.getPhotoTypes,
        headers: [:],
        parameters: ["format":"json"],
        method: .get,
        body: [:])
    
    init(photosNetworkManager: NetworkManagerProtocol = NetworkManager()) {
        self.photosNetworkManager = photosNetworkManager
    }
    
    /// Function for loading information about Photos from server
    /// - Parameter completion: completion for save data and return error
    /// - Parameter page: page of items
    func getPhotoTypes(page: String, completion: @escaping(_ error: Error?) -> Void) {
        urlPhotoRequest.parameters?.removeAll()
        urlPhotoRequest.parameters?.updateValue(page, forKey: "page")
        photosNetworkManager.load(
            service: urlPhotoRequest,
            decodeType: Response.self) { [weak self] result in
                switch result {
                case .success(let response):
                    print(response)
                    self?.response = response
                    self?.content += response.content
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    /// Function for uploading photo to swrver
    /// - Parameters:
    ///   - typeId: id of cell
    ///   - name: name of developer
    ///   - image: image
    ///   - completion: completion with error
    func uploadPhoto(typeId: Int, name: String, image: UIImage, completion: @escaping(_ error: Error?) -> Void) {
        urlPhotoRequest.body?.removeAll()
        urlPhotoRequest.method = .post
        urlPhotoRequest.path = .uploadPhoto
        urlPhotoRequest.body?.updateValue(name, forKey: name)
        urlPhotoRequest.body?.updateValue(typeId, forKey: "typeId")
        urlPhotoRequest.body?.updateValue(image, forKey: "photo")
        photosNetworkManager.request(service: urlPhotoRequest) { result in
            switch result {
            case .success(_):
                print(result)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    /// This function  provides correct row height value for different sizes of screens.
    func calculateRowHeight(from frameHeight: CGFloat) -> CGFloat {
        var rowHeight: CGFloat
        switch true {
        case frameHeight < 670: rowHeight = frameHeight / 4.5
        case frameHeight > 900: rowHeight = frameHeight / 5.5
        default: rowHeight = frameHeight / 5.2
        }
        return rowHeight
    }

    func getIdCell() -> Int {
        return idCell
    }
    func getIsLoading() -> Bool {
        return isLoading
    }
    func getPageNumb() -> Int {
        return pageNumb
    }
    func setIdCell(idCell: Int) {
        self.idCell = idCell
    }
    func setIsLoading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    func setPageNumb(pageNumb: Int) {
        self.pageNumb = pageNumb
    }
}
