//
//  NetworkManager.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import Foundation
import Alamofire

class NetworkManager: NetworkManagerProtocol  {
    let session: AFProtocol
    
    init(session: AFProtocol = AF) {
        self.session = session
    }
    
    /// Function for loading data from server
    /// - Parameters:
    ///   - service: some class which conform to  URLRequestProviderProtocol
    ///   - decodeType: a model for decorating data
    ///   - completion: completion which send the request and processes the response
    func load<U: Decodable>(
        service: URLRequestProviderProtocol,
        decodeType: U.Type,
        completion: @escaping(Result<U, Error>) -> Void) {
            guard let urlRequest = service.urlRequest
            else {
                return
            }
            let request = session.request(urlRequest, interceptor: nil)
            request.responseDecodable(of: decodeType) { (response) in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    /// Function for request to server
    /// - Parameters:
    ///   - service: some class which conform to  URLRequestProviderProtocol
    ///   - completion: completion with result
    func request (service: URLRequestProviderProtocol, completion: @escaping(Result<Data?, Error>) -> Void) {
        guard let urlRequest = service.urlRequest
        else {
            return
        }
        let request = session.request(urlRequest, interceptor: nil)
        request.response { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

