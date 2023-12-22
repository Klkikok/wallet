//
//  Resource.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/8/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import Foundation
import UIKit

class Resource : NSObject
{
    var name:String = ""
    var imageName:String = ""
    var mainCurrency:String = ""
    var mainCurrencyValue:Double = 0
    var otherCurrencies:[Currency] = [Currency(), Currency(), Currency()]
    
    override init()
    {
        super.init()
    }
    
    init(name: String, imageName: String = "Wallet", firstCurrency: String, secondCurrency: String, thirdCurrency: String)
    {
        self.name = name
        self.imageName = imageName
        self.mainCurrency = firstCurrency
        self.otherCurrencies[0].name = firstCurrency
        self.otherCurrencies[1].name = secondCurrency
        self.otherCurrencies[2].name = thirdCurrency
    }
    
    
    init(dict: Dictionary<String, String>)
    {
        if let n = dict["name"]
        {
            self.name = n
        }
        
        if let imn = dict["imageName"]
        {
            self.imageName = imn
        }
        
        if let mc = dict["mainCurrency"]
        {
            self.mainCurrency = mc
        }
        if let mcv = dict["mainCurrencyValue"]
        {
            self.mainCurrencyValue = Double(mcv)!
        }
        
        if let fc = dict["firstCurrency"]
        {
            self.otherCurrencies[0].name = fc
        }
        
        if let fcv = dict["firstCurrencyValue"]
        {
            self.otherCurrencies[0].value = Double(fcv)!
        }
        
        if let sc = dict["secondCurrency"]
        {
            self.otherCurrencies[1].name = sc
        }
        
        if let scv = dict["secondCurrencyValue"]
        {
            self.otherCurrencies[1].value = Double(scv)!
        }
        
        if let tc = dict["thirdCurrency"]
        {
            self.otherCurrencies[2].name = tc
        }
        
        if let tcv = dict["thirdCurrencyValue"]
        {
            self.otherCurrencies[2].value = Double(tcv)!
        }
    }
    
    func GetDict() -> Dictionary<String, String>
    {
        let dict:Dictionary<String, String> = ["name" : self.name, "imageName" : self.imageName, "mainCurrency" : self.mainCurrency, "mainCurrencyValue" : String(self.mainCurrencyValue), "firstCurrency" : self.otherCurrencies[0].name, "firstCurrencyValue" : String(self.otherCurrencies[0].value), "secondCurrency" : self.otherCurrencies[1].name, "secondCurrencyValue" : String(self.otherCurrencies[1].value), "thirdCurrency" : self.otherCurrencies[2].name, "thirdCurrencyValue" : String(self.otherCurrencies[2].value)]
        
        return dict
    }
    
    func HasCurrency(currency: String) -> Bool
    {
        var rtn = false
        for temp in otherCurrencies
        {
            if(temp.name == currency)
            {
                rtn = true
            }
        }
        return rtn
    }
    
    func FindCurrency(currency: String) -> Int
    {
        var rtn = -1
        var i = 0
        for temp in otherCurrencies
        {
            if(temp.name == currency)
            {
                rtn = i
            }
            i += 1
        }
        
        return rtn
    }
    func Add(dest: String, value: Double)
    { 
        if (dest == "firstCurrencyValue")
        {
            otherCurrencies[0].value += value
        }
        else if (dest == "secondCurrencyValue")
        {
            otherCurrencies[1].value += value
        }
        else if (dest == "thirdCurrencyValue")
        {
            otherCurrencies[2].value += value
        }
    }
    
    func AddAtIndex(dest: Int, value: Double)
    {
        otherCurrencies[dest].value += value
    }
    
    func Remove(from: String, value: Double)
    {
        if (from == "firstCurrencyValue")
        {
            if(otherCurrencies[0].value >= value)
            {
                otherCurrencies[0].value -= value
            }
        }
            
        else if (from == "secondCurrencyValue")
        {
            if(otherCurrencies[1].value >= value)
            {
                otherCurrencies[1].value -= value
            }
        }
            
        else if (from == "thirdCurrencyValue")
        {
            if(otherCurrencies[2].value >= value)
            {
                otherCurrencies[2].value -= value
            }
        }
    }
    
    func RemoveAtIndex(from: Int, value: Double)
    {
        if(otherCurrencies[from].value >= value)
        {
            otherCurrencies[from].value -= value
        }
    }
}
