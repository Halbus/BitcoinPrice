//
//  PriceViewModel.swift
//  BitcoinPrice
//
//  Created by Luciano Puzer on 22/02/22.
//

import Foundation
import Combine

class PriceViewModel: ObservableObject {
    @Published public private(set) var lastUpdated: String = ""
    @Published public private(set) var priceModel: [PriceModel] = Currency.allCases.map {
        PriceModel(currency: $0)
    }
    
    private var subscription: AnyCancellable?
    
    public func onAppear() {
        subscription = CoindeskAPIService.shared
            .fetchBitcoinPrice()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("sucess!")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.lastUpdated = value.time.updated
                self.priceModel = [
                    PriceModel(currency: .usd, rate: value.bpi.USD.rate),
                    PriceModel(currency: .gbp, rate: value.bpi.GBP.rate),
                    PriceModel(currency: .eur, rate: value.bpi.EUR.rate)
                ]
            })
    }
}


