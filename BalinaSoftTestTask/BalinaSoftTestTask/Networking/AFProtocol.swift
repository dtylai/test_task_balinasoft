//
//  AFProtocol.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import Foundation
import Alamofire

protocol AFProtocol {
    
    func request(_ convertible: URLRequestConvertible,
                 interceptor: RequestInterceptor?) -> DataRequest
}

extension Session: AFProtocol {}
