//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var convertedValueLabel: UILabel!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    @IBOutlet weak var currenciesPicker: UIPickerView!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currenciesPicker.delegate = self
        currenciesPicker.dataSource = self
        coinManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK: - UIPickerViewDelegate
extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        selectedCurrencyLabel.text = coinManager.currencyArray[row]
        coinManager.getCurrentValue(Currency: coinManager.currencyArray[row])
        return coinManager.currencyArray[row]
    }
}


//MARK: - CoinManagerProtocol
extension ViewController:CoinManagerProtocol{
    func didConversionHappend(_ coinManager: CoinManager, _ coinModel: CoinModel) {
        DispatchQueue.main.async {
            self.convertedValueLabel.text = String(format: "%.5f", coinModel.rate)
        }
    }
    
    func didFailedWithError(_ error: Error) {
        print(error)
    }
}
