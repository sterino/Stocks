//
//  StocksViewModel.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import Foundation

final class StocksViewModel {
    var symbols: [Symbol]?
    var searchResults: [Symbol]? = []
    var favorites: [Symbol]? {
        return symbols?.filter { isFavorite(symbol: $0.symbol ) }
    }
    
    private let favoritesKey = "favoritesKey"
    private var isSearching = false
    
    func fetchSymbols(completion: @escaping () -> Void) {
        StocksManager.shared.fetchSymbols { [weak self] result in
            switch result {
            case .success(let symbols):
                self?.symbols = symbols
                completion()
            case .failure(let error):
                print("Failed to fetch symbols: \(error)")
            }
        }
    }
    
    func searchSymbols(query: String, completion: @escaping () -> Void) {
        isSearching = true
        StocksManager.shared.searchSymbol(query: query) { [weak self] result in
            switch result {
            case .success(let symbols):
                self?.searchResults = symbols
                completion()
            case .failure(let error):
                print("Failed to search symbols: \(error)")
            }
        }
    }

    func toggleFavorite(symbol: String) {
        var favorites = getFavorites()
        if favorites.contains(symbol) {
            favorites.removeAll { $0 == symbol }
        } else {
            favorites.append(symbol)
        }
        saveFavorites(favorites)
    }
    
    func isFavorite(symbol: String) -> Bool {
        return getFavorites().contains(symbol)
    }
    
    private func getFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    private func saveFavorites(_ favorites: [String]) {
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func getCurrentSymbols() -> [Symbol] {
        if isSearching {
            return searchResults ?? []
        } else {
            return symbols ?? []
        }
    }

    func stopSearching() {
        isSearching = false
    }
}

