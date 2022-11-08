//
//  Models.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import Foundation

struct Response: Codable {
    let page, pageSize, totalPages, totalElements: Int
    let content: [Content]
}

struct Content: Codable {
    let id: Int
    let name: String
    let image: String?
}
