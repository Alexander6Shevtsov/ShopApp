//
//  MainContracts.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import UIKit

enum MainViewState {
    case loading
    case data([CellViewModel])
    case error(String)
}

protocol MainView: AnyObject {
    func render(_ state: MainViewState)
    func showGreeting(_ text: String)
}

protocol PresenterType: AnyObject {
    func viewDidLoad()
    func didTapGreeting()
}

protocol InteractorType: AnyObject {
    func fetchProducts() async throws -> [Product]
}

struct CellViewModel: Hashable {
    let id: Int
    let title: String
    let price: String
}
