//
//  AppCoordinator.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 18.08.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    private let sessionStore: SessionStoreType
    
    init(window: UIWindow, sessionStore: SessionStoreType = UserDefaultsSessionStore()) {
        self.window = window
        self.sessionStore = sessionStore
        navigationController.navigationBar.prefersLargeTitles = true
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
        let vc = MainPlaceholderViewController(userName: sessionStore.userName)
        vc.title = "Главный экран"
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showMainReplacingStack() {
        let vc = MainPlaceholderViewController(userName: sessionStore.userName)
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

final class MainPlaceholderViewController: UIViewController {
    private let userName: String?
    
    init(userName: String?) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError( "init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Здравствуйте\(userName.flatMap { ", \($0)" } ?? "")!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
