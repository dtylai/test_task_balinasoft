//
//  URLRequestProviderProtocol.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import Foundation
import Alamofire

/// Enum with methods for request
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Enum with paths for request
public enum Paths: String {
    case getPhotoTypes = "api/v2/photo/type"
    case uploadPhoto = "api/v2/photo"
}

public typealias Parameters = [String: Any]

public typealias HTTPBody = [String: Any]

public typealias HTTPHeaders = [String: String]

/// Protocol for creating URL request
public protocol URLRequestProviderProtocol: URLRequestConvertible {
    var baseURLString: String { get }
    var path: Paths { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var body: HTTPBody? { get }
}

