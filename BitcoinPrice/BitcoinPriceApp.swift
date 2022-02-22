//
//  BitcoinPriceApp.swift
//  BitcoinPrice
//
//  Created by Luciano Puzer on 22/02/22.
//

import SwiftUI

@main
struct BitcoinPriceApp: App {
    var body: some Scene {
        WindowGroup {
            PriceView(viewModel: PriceViewModel())
        }
    }
}
