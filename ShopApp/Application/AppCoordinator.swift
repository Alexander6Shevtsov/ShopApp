//
//  AppCoordinator.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 18.08.2025.
//

import UIKit
import SwiftUI

final class AppCoordinator {
    // UI
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    // Session
    private let sessionStore: SessionStoreType
    
    // Networking
    private let httpClient: ClientType
    private lazy var productsAPI: ProductsAPIType = StoreProductsAPI(client: httpClient)
    
    init(
        window: UIWindow,
        sessionStore: SessionStoreType = UserDefaultsSessionStore(),
        httpClient: ClientType = DefaultClient()
    ) {
        self.window = window
        self.sessionStore = sessionStore
        self.httpClient = httpClient
        navigationController.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground() // убирает “прозрачные” состояния
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
    }
    
    func start() {
        if sessionStore.isRegistered {
            showMain()
        } else {
            showRegistration()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showRegistration() {
        let vm = RegistrationViewModel(sessionStore: sessionStore)
        vm.onSuccess = { [weak self] in
            self?.showMainReplacingStack()
        }
        
        let view = RegistrationView(viewModel: vm)
            let host = UIHostingController(rootView: view)
            host.title = "Регистрация"
        
        navigationController.setViewControllers([host], animated: false)
    }
    
    private func showMain() {
        let vc = Module.make(api: productsAPI, sessionStore: sessionStore)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showMainReplacingStack() {
        let vc = Module.make(api: productsAPI, sessionStore: sessionStore)
        navigationController.setViewControllers([vc], animated: true)
    }
}
