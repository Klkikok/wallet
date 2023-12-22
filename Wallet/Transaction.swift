//
//  Transaction.swift
//  Wallet
//
//  Created by Milan Zezelj on 6/17/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import Foundation
import UIKit

enum TransactionType : String
{
    case deposit = "deposit"
    case withdraw = "withdraw"
//    case exchange = "exchange"
//    case transfer = "transfer"
}
class Transaction
{
    var value:Double = 0.0
    var resourceName:String = ""
    var currency:String = ""
    var type:TransactionType = TransactionType.deposit
    var comment:String = ""
    
    init()
    {
        value = 0
        resourceName = ""
        currency = ""
        type = TransactionType.deposit
        comment = ""
    }
    
    init(value: Double, resourceName : String, currency : String, type:TransactionType, comment: String)
    {
        self.value = value
        self.resourceName = resourceName
        self.currency = currency
        self.type = type
        self.comment = comment
    }

    
    func getDict() -> Dictionary<String, String>
    {
        let dict:Dictionary<String, String> = ["value" : String(value), "resourceName": resourceName, "currency": currency, "type" : type.rawValue, "comment" : comment]
        
        return dict
    }
    
    init(dict: Dictionary<String, String>)
    {
        if let v = dict["value"]
        {
            self.value = Double(v)!
        }
        
        if let rn = dict["resourceName"]
        {
            self.resourceName = rn
        }
        
        if let c = dict["currency"]
        {
            self.currency = c
        }
        
        if let t = dict["type"]
        {
            self.type = TransactionType(rawValue: t)!
        }
        
        if let c = dict["comment"]
        {
            self.comment = c
        }
        
    }
    
    static func getArray(dict: [Dictionary<String, String>]) -> [Transaction]
    {
        var transactions = [Transaction]()
        for temp in dict
        {
            transactions.append(Transaction(dict: temp))
        }
        
        return transactions
    }
}
