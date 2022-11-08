//
//  PhotoTypesModel.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit

class PhotoTypesModel {
    private(set) var content = [Content]()
    private(set) var response: Response?
    var photosNetworkManager: NetworkManagerProtocol
    
    let photoCellIdentifier: String = String(describing: PhotoTypeCell.self)
    let loadingCellIndentifier: String = String(describing: LoadingCell.self)
    let urlPhotoRequest = URLRequestProvider(
        baseURL: "http://junior.balinasoft.com",
        path:.getPhotoTypes,
        headers: nil,
        parameters: ["format":"json"],
        method: .get,
        body: nil)
    
    init(photosNetworkManager: NetworkManagerProtocol = NetworkManager()) {
        self.photosNetworkManager = photosNetworkManager
    }
    
    /// Function for loading information about Photos from server
    /// - Parameter completion: completion for save data and return error
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
}
