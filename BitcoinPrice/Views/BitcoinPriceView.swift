//
//  ContentView.swift
//  BitcoinPrice
//
//  Created by Luciano Puzer on 22/02/22.
//

import SwiftUI


struct PriceView: View {
    @ObservedObject var viewModel: PriceViewModel
    @State private var selectedCurrency: Currency = .usd
    
    var body: some View {
        
        VStack (spacing: 0) {
            Text( "Updated \(viewModel.lastUpdated)")
                .padding([.top, .bottom])
                .foregroundColor(.bitcoinGreen)
            
            TabView(selection: $selectedCurrency) {
                ForEach(viewModel.priceModel.indices, id: \.self) { index in
                    let details = viewModel.priceModel[index]
                    BitcoinPriceView(priceModel: details)
                        .tag(details.currency)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            VStack(spacing: 0){
                HStack (alignment: .center) {
                    Picker(selection: $selectedCurrency, label: Text("Currency"), content: {
                        Text("\(Currency.usd.icon) \(Currency.usd.code)").tag(Currency.usd)
                        Text("\(Currency.gbp.icon) \(Currency.gbp.code)").tag(Currency.gbp)
                        Text("\(Currency.eur.icon) \(Currency.eur.code)").tag(Currency.eur)

                    })
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: viewModel.onAppear, label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                    })
                        .padding(.trailing)
                }
                .padding(.top)
                Link(
                "Powered by coinDesk",
                destination: URL(string: "https://coindesk.com/price/bitcoin")!
                )
                    .font(.caption)
            }
            .foregroundColor(.bitcoinGreen)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .pickerStyle(MenuPickerStyle())
        
    }
}


struct BitcoinPriceView: View {
    let priceModel: PriceModel
    var body: some View {
        ZStack {
            Color.bitcoinGreen
            VStack {
                Text(priceModel.currency.icon)
                    .font(.largeTitle)
                Text("1 Bitcoin =")
                    .bold()
                    .font(.title2)
                Text("\(priceModel.rate) \(priceModel.currency.code)")
                    .bold()
                    .font(.largeTitle)
            }.foregroundColor(.white)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PriceView()
//    }
//}

extension Color {
    static let bitcoinGreen: Color = Color.green.opacity(0.9)
}
