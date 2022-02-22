//
//  CoindeskAPIService.swift
//  BitcoinPrice
//
//  Created by Luciano Puzer on 22/02/22.
//

import Foundation
import Combine

struct CoindeskAPIService {
    public static let shared = CoindeskAPIService()
    
    public func fetchBitcoinPrice() -> AnyPublisher<APIResponse, Error> {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            let error = URLError(.badURL)
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                guard httpResponse.statusCode == 200 else {
                    let code = URLError.Code(rawValue: httpResponse.statusCode)
                    throw URLError(code)
                }
                return data
            })
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct APIResponse: Decodable {
    let time: APItime
    let bpi: APIBitcoinPriceIndex
}


struct APItime: Decodable {
    let updated: String
}


struct APIBitcoinPriceIndex: Decodable {
    let USD: APIPriceDate
    let GBP: APIPriceDate
    let EUR: APIPriceDate
}


struct APIPriceDate: Decodable {
    let rate:String

}
