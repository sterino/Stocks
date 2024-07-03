//
//  Symbol.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import Foundation

struct Symbol: Decodable {
    let description: String
    let displaySymbol: String?
    let figi: String?
    let mic: String?
    let symbol: String
    let type: String?
}

