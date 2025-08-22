//
//  Interactor.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

final class Interactor: InteractorType {
    private let api: ProductsAPIType
    
    init(api: ProductsAPIType) {
        self.api = api
    }
    
    func fetchProducts() async throws -> [Product] {
        try await api.fetchProducts()
    }
}
