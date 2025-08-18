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
    
    init(window: UIWindow) {
        self.window = window
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let vc = PlaceholderViewController()
        navigationController.setViewControllers([vc], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
//    func showRegistration() { }
//    func showMain() { }
}

final class PlaceholderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "ShopApp"
    }
}
