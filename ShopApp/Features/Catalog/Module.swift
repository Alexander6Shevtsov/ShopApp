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
        guard let userName = sessionStore.userName, !userName.isEmpty else {
            fatalError("Пожалуйста зарегистрируйтесь")
        }
        
        let viewController = ViewController()
        let interactor = Interactor(api: api)
        let presenter = Presenter(
            view: viewController,
            interactor: interactor,
            userName: userName
        )
        viewController.setPresenter(presenter)
        return viewController
    }
}
