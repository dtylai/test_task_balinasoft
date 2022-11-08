//
//  NetworkManagerProtocol.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func load<U: Decodable>(
        service: URLRequestProviderProtocol,
        decodeType: U.Type,
        completion: @escaping(Result<U, Error>) -> Void)
}
