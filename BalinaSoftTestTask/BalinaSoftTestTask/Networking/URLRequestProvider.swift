//
//  URLRequestProvider.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

class URLRequestProvider: URLRequestProviderProtocol {
    var baseURLString: String
    var path: Paths
    var headers: HTTPHeaders?
    var parameters: Parameters?
    var method: HTTPMethod
    var body: HTTPBody?
    
    /// Сlass initializer
    /// - Parameters:
    ///   - baseURL: come class wit
    ///   - path: path of request
    ///   - headers: headers of request
    ///   - parameters: parametrs of request
    ///   - method: method of request
    ///   - body: body of request
    init(
        baseURL: String,
        path: Paths,
        headers: HTTPHeaders?,
        parameters: Parameters?,
        method: HTTPMethod,
        body: HTTPBody?) {
            self.baseURLString = baseURL
            self.path = path
            self.headers = headers
            self.parameters = parameters
            self.method = method
            self.body = body
        }
    
}

extension URLRequestProvider {
    
    /// Function for creating request
    /// - Returns: returns the request that we will send to the server
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path.rawValue))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .get:
            request.allHTTPHeaderFields = headers
            request = try URLEncoding.default.encode(request, with: parameters)
        case .post:
            request.allHTTPHeaderFields = headers
            var flag = false
            body.map { bodyy in
                if let image = bodyy["photo"] as? UIImage {
                    flag = true
                    let data = image.pngData()!
                    request.httpBody = data
                } else { flag = false }
                if !flag {
                    let jsonData = try? JSONSerialization.data(withJSONObject: bodyy)
                    request.httpBody! += jsonData!
                }
            }
        }
        return request
    }
}

