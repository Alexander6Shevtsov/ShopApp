//
//  MainPlaceholderViewController.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 19.08.2025.
//

import UIKit

final class MainPlaceholderVC: UIViewController {
    private let userName: String?
    private let productsAPI: ProductsAPIType
    
    init(userName: String?, productsAPI: ProductsAPIType) {
        self.userName = userName
        self.productsAPI = productsAPI
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable) required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Главный экран"
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Добро пожаловать\(userName.flatMap { ", \($0)" } ?? "")!"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        Task { [productsAPI] in
            do {
                let items = try await productsAPI.fetchProducts()
                print("Fetched products count: \(items.count)")
            } catch {
                print("API error: \(error)")
            }
        }
    }
}
