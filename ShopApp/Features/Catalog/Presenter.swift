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
    private let sessionStore: SessionStoreType
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    init(view: MainView, interactor: InteractorType, sessionStore: SessionStoreType) {
        self.view = view
        self.interactor = interactor
        self.sessionStore = sessionStore
    }
    
    func viewDidLoad() {
        view?.render(.loading)
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
        }
    }
    
    func didTapGreeting() {
        let name = sessionStore.userName ?? "гость"
        view?.showGreeting("Привет, \(name)!")
    }
    
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
