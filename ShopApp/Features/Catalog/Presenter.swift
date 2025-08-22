//
//  Presenter.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

@MainActor
final class Presenter: PresenterType {
    private weak var view: MainView?
    private let interactor: InteractorType
    private let userName: String
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    init(view: MainView, interactor: InteractorType, userName: String) {
        self.view = view
        self.interactor = interactor
        self.userName = userName
    }
    
    func viewDidLoad() {
        view?.render(.loading)
        Task { [interactor, weak view] in
            do {
                let products = try await interactor.fetchProducts()
                let models = products.map {
                    CellViewModel(
                        id: $0.id,
                        title: $0.title,
                        price: formatter.string(from: NSNumber(value: $0.price)) ?? "\($0.price)"
                    )
                }
                await MainActor.run { view?.render(.data(models)) }
            } catch {
                await MainActor.run { view?.render(.error("Не удалось загрузить список")) }
            }
        }
    }
    
    func didTapGreeting() { view?.showGreeting("Привет, \(userName)!") }
    
    func didPullToRefresh() {
        Task { [interactor, weak view] in
            do {
                let products = try await interactor.fetchProducts()
                let models = products.map { product in
                    CellViewModel(
                        id: product.id,
                        title: product.title,
                        price: formatter.string(from: NSNumber(value: product.price)) ?? "\(product.price)"
                    )
                }
                await MainActor.run { view?.render(.data(models)) }
            } catch {
                await MainActor.run { view?.render(.error("Не удалось загрузить список")) }
            }
            await MainActor.run { view?.endRefreshing() }
        }
    }
}
