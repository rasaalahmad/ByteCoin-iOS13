//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerProtocol {
    func didConversionHappend(_ coinManager:CoinManager,_ coinModel:CoinModel)
    func didFailedWithError(_ error:Error)
}

struct CoinManager {
    var delegate:CoinManagerProtocol?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "727A9A1C-44A4-4505-89AD-7B850B3A602D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCurrentValue(Currency cur:String){
        let urlString = "\(baseURL)/\(cur)?apikey=\(apiKey)"
        performRequest(on:urlString)
    }
    
    private func performRequest(on urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url)  {(data, response, error) in
                if error != nil{
                    self.delegate?.didFailedWithError(error!)
                    return
                }
                            
                if let safeData = data {
                    if let coinManager = parseJSON(coinData: safeData){
                        self.delegate?.didConversionHappend(self, coinManager)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(coinData:Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            return CoinModel(rate: decodedData.rate)
        } catch{
            print(error)
            self.delegate?.didFailedWithError(error)
            return nil
        }
    }
        
}
    

