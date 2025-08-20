//
//  Presenter.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import Foundation

final class Presenter: PresenterType {
    private weak var view: MainView?
    private let interactor: InteractorType
    private let sessionStore: SessionStoreType
    
    private lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "ru_RU")
        return f
    }()
    
    init(
        view: MainView,
        interactor: InteractorType,
        sessionStore: SessionStoreType
    ) {
        self.view = view
        self.interactor = interactor
        self.sessionStore = sessionStore
    }
    
    func viewDidLoad() {
        view?.render(.loading)
        Task {
            do {
                let items = try await interactor.fetchProducts()
                let vms = items.map { p in
                    CellViewModel(
                        id: p.id,
                        title: p.title,
                        price: formatter.string(from: NSNumber(value: p.price)) ?? "\(p.price)"
                    )
                }
                view?.render(.data(vms))
            } catch {
                view?.render(.error("Не удалось загрузить список"))
            }
        }
    }
    
    func didTapGreeting() {
        let name = sessionStore.userName ?? "гость"
        view?.showGreeting("Привет, \(name)!")
    }
}
