//
//  StocksViewController.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import UIKit
import SnapKit

final class StocksViewController: UIViewController, UISearchBarDelegate {
    
    private let viewModel = StocksViewModel()
    private var isShowingFavorites = false
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Find company or ticker"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var stocksLabel: UILabel = {
            let label = UILabel()
            label.text = "Stocks"
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStocksTapped))
            label.addGestureRecognizer(tapGesture)
            return label
        }()
    
    private lazy var favouriteLabel: UILabel = {
           let label = UILabel()
           label.text = "Favourite"
           label.font = UIFont.systemFont(ofSize: 16)
           label.textColor = .lightGray
           label.isUserInteractionEnabled = true
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavouriteTapped))
           label.addGestureRecognizer(tapGesture)
           return label
       }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stocksLabel, favouriteLabel])
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .bottom
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
        setupUI()
    }
    
    @objc private func handleStocksTapped() {
        isShowingFavorites = false
        viewModel.stopSearching()
        updateTabSelection()
    }
        
    @objc private func handleFavouriteTapped() {
        isShowingFavorites = true
        viewModel.stopSearching()
        updateTabSelection()
    }
    
    private func updateTabSelection() {
        stocksLabel.textColor = isShowingFavorites ? .lightGray : .black
        favouriteLabel.textColor = isShowingFavorites ? .black : .lightGray
        stocksLabel.font = isShowingFavorites ? UIFont.boldSystemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 24)
        favouriteLabel.font = isShowingFavorites ? UIFont.boldSystemFont(ofSize: 24) : UIFont.boldSystemFont(ofSize: 16)
        
        tableView.reloadData()
    }

    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(labelsStackView)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func fetchData() {
        viewModel.fetchSymbols {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.stopSearching()
            tableView.reloadData()
        } else {
            viewModel.searchSymbols(query: searchText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if isShowingFavorites {
           return viewModel.favorites?.count ?? 0
       } else {
           return viewModel.getCurrentSymbols().count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as? StocksTableViewCell else { return UITableViewCell() }
        
        let symbol: Symbol?
        if isShowingFavorites {
            symbol = viewModel.favorites?[indexPath.row]
        } else {
            symbol = viewModel.getCurrentSymbols()[indexPath.row]
        }
        let isFavorite = viewModel.isFavorite(symbol: symbol?.symbol ?? "")
        
        cell.configure(symbol: symbol?.symbol ?? "", subtitle: symbol?.description ?? "", isFavorite: isFavorite)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .systemGray6
        } else {
            cell.backgroundColor = .white
        }
        
        cell.favoriteTapped = { [weak self] in
                   guard let self = self, let symbol = symbol?.symbol else { return }
                   self.viewModel.toggleFavorite(symbol: symbol)
                   if self.isShowingFavorites {
                       if indexPath.row < (self.viewModel.favorites?.count ?? 0) {
                           tableView.reloadRows(at: [indexPath], with: .automatic)
                       } else {
                           tableView.reloadData()
                       }
                   } else {
                       tableView.reloadRows(at: [indexPath], with: .automatic)
                   }
               }
        return cell
    }
}
