//
//  StocksManager.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import Foundation
import Alamofire

class StocksManager {
    static let shared = StocksManager()

    private init() {}

    func fetchSymbols(completion: @escaping (Result<[Symbol], Error>) -> Void) {
        let parameters: Parameters = [
            "exchange": "US",
            "token": Global.APIs.Keys.stocks
        ]

        AF.request(Global.APIs.URLs.Stocks.stocksList, parameters: parameters).responseDecodable(of: [Symbol].self) { response in
            switch response.result {
            case .success(let symbols):
                completion(.success(symbols))
            case .failure(let error):
                print("Ошибка при загрузке символов")
                completion(.failure(error))
            }
        }
    }

    func fetchSymbolQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        let parameters: Parameters = [
            "symbol": "AAPL",
            "token": Global.APIs.Keys.stocks
        ]
        
        AF.request(Global.APIs.URLs.Stocks.stocksQuote, parameters: parameters).responseDecodable(of: Quote.self) { response in
            switch response.result {
            case .success(let quote):
                completion(.success(quote))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchSymbol(query: String, completion: @escaping (Result<[Symbol], Error>) -> Void) {
        let parameters: Parameters = [
            "q": query,
            "token": Global.APIs.Keys.stocks
        ]
        
        AF.request(Global.APIs.URLs.Stocks.stocksSearch, parameters: parameters).responseDecodable(of: SearchSymbol.self) { response in
            switch response.result {
            case .success(let searchResult):
                completion(.success(searchResult.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
