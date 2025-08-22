//
//  ViewController.swift
//  ShopApp
//
//  Created by Alexander Shevtsov on 17.08.2025.
//

import UIKit

final class ViewController: UIViewController, MainView {
    
    private var presenter: PresenterType!
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<Int, CellViewModel>!
    private let spinner = UIActivityIndicatorView(style: .large)
    private let refresh = UIRefreshControl()
    
    func setPresenter(_ presenter: PresenterType) { self.presenter = presenter }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Главный экран"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Приветствие",
            style: .plain,
            target: self,
            action: #selector(greetingTapped)
        )
        
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        dataSource = UITableViewDiffableDataSource<Int, CellViewModel>(tableView: tableView) { table, indexPath, viewModel in
            let cell = table.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as! Cell
            cell.configure(with: viewModel)
            return cell
        }
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        presenter.viewDidLoad()
    }
    
    @objc private func greetingTapped() { presenter.didTapGreeting() }
    @objc private func onRefresh() { presenter.didPullToRefresh() }
    
    // MARK: - MainView
    
    func render(_ state: StateView) {
        switch state {
        case .loading:
            spinner.startAnimating()
        case .data(let models):
            spinner.stopAnimating()
            var snapshot = NSDiffableDataSourceSnapshot<Int, CellViewModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(models, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        case .error(let message):
            spinner.stopAnimating()
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func endRefreshing() { refresh.endRefreshing() }
    
    func showGreeting(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
