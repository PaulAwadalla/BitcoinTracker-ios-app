//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Paul Awadalla on 9/18/2019.
//  Copyright © 2019 Paul Awadalla. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["USD"]
    var finalURL = ""

    let currencySymbols = ["$"]
    var currencySymbolsSelected = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinWeeklyLabelPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //setting the degegate and dataSource to self indicating that we are using this viewController.
       currencyPicker.delegate = self
       currencyPicker.dataSource = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    //determing how many columns we want in our picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //telling xcode how many rows we want in our picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // adding titles for our user to see which currency they want to pick.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    // telling xcode which currency the user picked it fetch the right data
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //basically we are combining base url and what the user picked curreny so we can tell xcode what to request from the API.
        finalURL = baseURL + currencyArray[row]
        currencySymbolsSelected = currencySymbols[row]
        getCurrentBitCoinPrice(url: finalURL)
    }
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    func getCurrentBitCoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the BitCoin Price")
                    let bitCoinPriceJSON : JSON = JSON(response.result.value!)
                    self.updateBitCoinData(json: bitCoinPriceJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinData(json : JSON) {
        
        if let BitCoinResult = json["averages"]["day"].double {
           bitcoinPriceLabel.text = currencySymbolsSelected + String(BitCoinResult)
            let weekyBitcoinPrice = json["averages"]["week"].stringValue
           bitcoinWeeklyLabelPrice.text = currencySymbolsSelected + weekyBitcoinPrice
            
        }
        else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
      
    }
    




}

