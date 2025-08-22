//
//  Module.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 20.08.2025.
//

import UIKit

@MainActor
enum Module {
    static func make(api: ProductsAPIType, sessionStore: SessionStoreType) -> UIViewController {
        let view = ViewController()
        let interactor = Interactor(api: api)
        let presenter = Presenter(view: view, interactor: interactor, sessionStore: sessionStore)
        view.setPresenter(presenter)
        return view
    }
}
