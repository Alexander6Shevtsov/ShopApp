//
//  NetworkError.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 19.08.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case nonHTTPResponse
    case badStatus(Int, Data?)
    case decoding(Error)
}
