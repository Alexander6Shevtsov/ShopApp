//
//  AppCoordinator.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 18.08.2025.
//

import UIKit

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
    
    // Переход на экран регистрации (плейсхолдер)
    private func showRegistration() {
        let vc = RegistrationPlaceholderViewController()
        vc.title = "Регистрация"
        // Пример: по нажатию "Завершить" установим флаг и перейдём на Main.
        vc.onFinish = { [weak self] name in
            self?.sessionStore.userName = name
            self?.sessionStore.isRegistered = true
            self?.showMainReplacingStack()
        }
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // Переход на главный экран (плейсхолдер)
    private func showMain() {
        let vc = MainPlaceholderVC(
            userName: sessionStore.userName,
            productsAPI: productsAPI
        )
        vc.title = "Главный экран"
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showMainReplacingStack() {
        let vc = MainPlaceholderVC(
            userName: sessionStore.userName,
            productsAPI: productsAPI
        )
        vc.title = "Главный экран"
        navigationController.setViewControllers([vc], animated: true)
    }
}

// Плейсхолдер экрана регистрации
final class RegistrationPlaceholderViewController: UIViewController {
    var onFinish: ((String) -> Void)?
    
    private let button = UIButton(type: .system)
    private let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        textField.placeholder = "Введите имя"
        textField.borderStyle = .roundedRect
        
        button.setTitle("Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [textField, button])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func finishTapped() {
        onFinish?(textField.text ?? "")
    }
}
