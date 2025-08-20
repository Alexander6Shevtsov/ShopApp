//
//  ProductsAPI.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 19.08.2025.
//

import Foundation

protocol ProductsAPIType: AnyObject {
    func fetchProducts() async throws -> [Product]
}

final class StoreProductsAPI: ProductsAPIType {
    private let client: ClientType
    private let decoder: JSONDecoder
    private let baseURL = URL(string: "https://fakestoreapi.com")!
    
    init(client: ClientType, decoder: JSONDecoder = .init()) {
        self.client = client
        self.decoder = decoder
    }
    
    func fetchProducts() async throws -> [Product] {
        let url = baseURL.appendingPathComponent("products")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await client.data(for: request)
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.badStatus(response.statusCode, data)
        }
        
        do {
            return try decoder.decode([Product].self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
