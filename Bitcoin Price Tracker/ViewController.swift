//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Andres Felipe De La Ossa Navarro on 10/19/18.
//  Copyright © 2018 Andres Felipe De La Ossa Navarro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var copLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDefaultPrices(currencyCode: "USD", thelabel: usdLabel)
        getDefaultPrices(currencyCode: "EUR", thelabel: eurLabel)
        getDefaultPrices(currencyCode: "COP", thelabel: copLabel)
        getPrice()
    }
    func getDefaultPrices(currencyCode:String,thelabel:UILabel) {
        let price = UserDefaults.standard.double(forKey: currencyCode)
        if price != 0.0 {
            thelabel.text = (self.double2Money(price: price, currencyCode: currencyCode))! + "-"
        }
    }
    
    func getPrice() {
        if let url =  URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,EUR,COP") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print("it worked")
                    if let json =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double]{
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                            if let usd = jsonDictionary["USD"] {
                                self.usdLabel.text = self.double2Money(price: usd, currencyCode: "USD")
                                UserDefaults.standard.set(usd, forKey: "USD")
                                }
                                if let eur = jsonDictionary["EUR"] {
                                    
                                    self.eurLabel.text = self.double2Money(price: eur, currencyCode: "EUR")
                                    UserDefaults.standard.set(eur, forKey: "EUR")
                                }
                                if let cop = jsonDictionary["COP"] {
                                    self.copLabel.text = self.double2Money(price: cop, currencyCode: "COP")
                                    UserDefaults.standard.set(cop, forKey: "COP")
                                }
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                }else {
                    print("ñie")
                }
            }.resume()
        }
    }
    func double2Money(price:Double,currencyCode: String)-> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "ERROR"
        } else {
            return priceString!
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getPrice()
    }
}

