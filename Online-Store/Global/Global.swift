//
//  Global.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import Foundation


struct Global{
    struct APIs {
        struct URLs{
            struct Stocks {
                static let stocksList = "https://finnhub.io/api/v1/stock/symbol"
                static let stocksQuote = "https://finnhub.io/api/v1/quote"
                static let stocksSearch = "https://finnhub.io/api/v1/search"
            }
        }
        struct Keys{
            static let stocks = "cq2itkpr01ql95ncq7pgcq2itkpr01ql95ncq7q0"
        }
    }
}
