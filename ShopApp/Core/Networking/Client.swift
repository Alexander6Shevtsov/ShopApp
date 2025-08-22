//
//  Client.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 19.08.2025.
//

import Foundation
protocol ClientType: AnyObject {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

final class DefaultClient: ClientType {
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
    }
    
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTPResponse
            }
            return (data, http)
        } catch {
            throw NetworkError.transport(error)
        }
    }
}
