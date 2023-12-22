//
//  AddTransactionViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 6/18/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UITextFieldDelegate{

    
    let us = UserDefaults.standard
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var AmountTextField: UITextField!
    @IBOutlet weak var CommentTextView: UITextView!
    
    var transactionType:String = ""
    var homeVC:HomeViewController = HomeViewController()
    var currentResourceName:String = "Resource"
    var currentCurrency:String = "Currency"
    var currentAmount:Double = 0
    var currentComment:String = ""
    var availableAmount:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AmountTextField.delegate = self
        currentResourceName = homeVC.currentResourceName
        CurrencyLabel.text = currentCurrency
        
        if(currentCurrency != "Currency")
        {
            let index = homeVC.FindCurrency(currency: currentCurrency)
            
            switch(index)
            {
            case 0:
                availableAmount = homeVC.currentFirstCurrencyValue
                break
            case 1:
                availableAmount = homeVC.currentSecondCurrencyValue
                break
            case 2:
                availableAmount = homeVC.currentThirdCurrencyValue
                break
                
            default:
                break
            }
        }
    }
    
    
    @IBAction func PickCurrencyPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        pickerPopUpVC.arrayForPickerView = homeVC.currentCurrencies
        pickerPopUpVC.selected = homeVC.currentCurrencies[0]
        pickerPopUpVC.kind = "addTransaction"
        pickerPopUpVC.type = "currency"
        
        pickerPopUpVC.addTransactionVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    
    @IBAction func CancelPressed(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
    }
    @IBAction func DonePressed(_ sender: UIButton)
    {
        if(currentResourceName == "Resource")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a resource!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(currentCurrency == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a currency!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let resource = Resource(dict: us.dictionary(forKey: currentResourceName) as! Dictionary<String, String>)
        
            
            if(AmountTextField.text! == "")
            {
                let alertController = UIAlertController(title: "Error", message:
                    "Please enter the amount!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            else if let temp = Double(AmountTextField.text!)
            {
                if(resource.HasCurrency(currency: currentCurrency))
                {
                    
                    let index = resource.FindCurrency(currency: currentCurrency)
                    
                    if(transactionType == "withdraw")
                    {
                        if(temp <= resource.otherCurrencies[index].value)
                        {
                            let alertController = UIAlertController(title: "Confirmation", message:
                                "Are you sure you want to do this transaction?", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "No", style: .cancel))
                            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                                { action in
                                    resource.RemoveAtIndex(from: index, value: temp)
                                    self.us.set(resource.GetDict(), forKey: self.currentResourceName)
                                    
                                    let transaction = Transaction(value: temp, resourceName: self.currentResourceName, currency: self.currentCurrency, type: TransactionType(rawValue: self.transactionType)!, comment: self.CommentTextView.text)
                                    
                                    
                                    if let tr = self.us.array(forKey: "transactions") as? [Dictionary<String, String>]
                                    {
                                        var transactions = tr
                                        transactions.insert(transaction.getDict(), at:0)
                                        self.us.set(transactions, forKey: "transactions")
                                    }
                                    
                                    self.homeVC.viewWillAppear(true)
                                    self.view.removeFromSuperview()
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "Error", message:
                                "Insufficient funds!\nCurrently available: " + String(availableAmount) + " " + currentCurrency, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    else if(transactionType == "deposit")
                    {
                        let alertController = UIAlertController(title: "Confirmation", message:
                            "Are you sure you want to do this transaction?", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
                        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                            { action in
                                resource.AddAtIndex(dest: index, value: temp)
                                self.us.set(resource.GetDict(), forKey: self.currentResourceName)
                                
                                
                                let transaction = Transaction(value: temp, resourceName: self.currentResourceName, currency: self.currentCurrency, type: TransactionType(rawValue: self.transactionType)!, comment: self.CommentTextView.text)
                                
                                
                                if let tr = self.us.array(forKey: "transactions") as? [Dictionary<String, String>]
                                {
                                    var transactions = tr
                                    transactions.insert(transaction.getDict(), at: 0)
                                    self.us.set(transactions, forKey: "transactions")
                                }
                                
                                self.homeVC.viewWillAppear(true)
                                self.view.removeFromSuperview()
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message:
                        "Invalid currency!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }

            else
            {
                let alertController = UIAlertController(title: "Error", message:
                    "Invalid value!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}
