//
//  Search.swift
//  Online-Store
//
//  Created by Aibatyr on 04.07.2024.
//

import Foundation

struct SearchSymbol: Decodable {
    let count: Int
    let result: [Symbol]
}

