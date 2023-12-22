//
//  Currency.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/8/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import Foundation

var rates = [
    "RSD" : 1,
    "EUR" : 0.0085,
    "USD" : 0.0096,
    "GBP" : 0.0073]

class Currency : NSObject
{
    var name:String = ""
    var value:Double = 0
    
    init(name:String, value:Double)
    {
        self.name = name
        self.value = value
        rates[name] = value
    }
    
    override init()
    {
        self.name = ""
        self.value = 0
    }
    static func getRates() -> Dictionary<String, Double>
    {
        return rates
    }
    static func Exchange(from: String, to: String, value: Double) -> Double
    {
        if(from != "RSD")
        {
            return round(value / rates[from]! * 100) / 100
        }
        else
        {
            return round(value * rates[to]! * 100) / 100
        }
    }
}
