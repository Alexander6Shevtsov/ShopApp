//
//  Product.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 19.08.2025.
//

import Foundation

struct Product: Decodable, Equatable {
    let id: Int
    let title: String
    let price: Double
}
