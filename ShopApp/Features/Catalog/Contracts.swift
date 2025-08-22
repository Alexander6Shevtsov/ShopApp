//
//  Contracts.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import UIKit

enum StateView {
    case loading
    case data([CellViewModel])
    case error(String)
}

@MainActor
protocol MainView: AnyObject {
    func render(_ state: StateView)
    func showGreeting(_ text: String)
    func endRefreshing()
}

@MainActor
protocol PresenterType: AnyObject {
    func viewDidLoad()
    func didTapGreeting()
    func didPullToRefresh()
}

protocol InteractorType: AnyObject {
    func fetchProducts() async throws -> [Product]
}

struct CellViewModel: Hashable {
    let id: Int
    let title: String
    let price: String
}
