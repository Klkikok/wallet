//
//  ExchangePopUpViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/27/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class ExchangePopUpViewController: UIViewController, UITextFieldDelegate
{
    let us = UserDefaults.standard
    @IBOutlet weak var AvailableAmountLabel: UILabel!
    var availableAmount:Double = -1
    var homeVC = HomeViewController()
    var currentResourceName = ""
    var pickedCurrencyFrom:String = "Currency"
    var pickedCurrencyTo:String = "Currency"
    var pickedAmount:Double = 0
    
    @IBOutlet weak var PickedCurrencyFromLabel: UILabel!
    @IBOutlet weak var PickedCurrencyToLabel: UILabel!
    @IBOutlet weak var AmountTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AmountTextField.delegate = self
        PickedCurrencyFromLabel.text = pickedCurrencyFrom
        PickedCurrencyToLabel.text = pickedCurrencyTo
        
        if(pickedCurrencyFrom != "Currency")
        {
            let index = homeVC.FindCurrency(currency: pickedCurrencyFrom)
            
            
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
        
        if(availableAmount != -1)
        {
            AvailableAmountLabel.text = String(availableAmount)
        }
    }
    
    
    @IBAction func pickCurrencyFromPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
            pickerPopUpVC.arrayForPickerView = homeVC.currentCurrencies
            if(pickedCurrencyTo != "Currency")
            {
                pickerPopUpVC.arrayForPickerView.remove(at: homeVC.currentCurrencies.firstIndex(of: pickedCurrencyTo)!)
            }
            pickerPopUpVC.selected = pickerPopUpVC.arrayForPickerView[0]
            pickerPopUpVC.kind = "exchange"
            pickerPopUpVC.type = "from"
        
        pickerPopUpVC.exchangeVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    
    @IBAction func pickCurrencyToPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        pickerPopUpVC.arrayForPickerView = homeVC.currentCurrencies
        if(pickedCurrencyFrom != "Currency")
        {
            pickerPopUpVC.arrayForPickerView.remove(at: homeVC.currentCurrencies.firstIndex(of: pickedCurrencyFrom)!)
        }
        pickerPopUpVC.selected = pickerPopUpVC.arrayForPickerView[0]
        pickerPopUpVC.kind = "exchange"
        pickerPopUpVC.type = "to"
        
        pickerPopUpVC.exchangeVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    
    @IBAction func donePressed(_ sender: UIButton)
    {
        if(pickedCurrencyFrom == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a currency you want to exchange!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(pickedCurrencyTo == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a currency you want to exchange to!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let resource = Resource(dict: us.dictionary(forKey: currentResourceName) as! Dictionary<String, String>)
            
            if(!resource.HasCurrency(currency: pickedCurrencyFrom))
            {
                let alertController = UIAlertController(title: "Error", message:
                    "Invalid start currency!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            else if(!resource.HasCurrency(currency: pickedCurrencyTo))
            {
                let alertController = UIAlertController(title: "Error", message:
                    "Invalid end currency!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let indexFrom = resource.FindCurrency(currency: pickedCurrencyFrom)
                let indexTo = resource.FindCurrency(currency: pickedCurrencyTo)
                
                if(AmountTextField.text! == "")
                {
                    let alertController = UIAlertController(title: "Error", message:
                        "Please enter the amount!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                else if let temp = Double(AmountTextField.text!)
                {
                    if(resource.otherCurrencies[indexFrom].value >= temp)
                    {
                        let alertController = UIAlertController(title: "Confirmation", message:
                            "Are you sure you want to do this exchange?", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
                        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                        { action in
                            resource.RemoveAtIndex(from: indexFrom, value: temp)
                            resource.AddAtIndex(dest: indexTo, value: Currency.Exchange(from: self.pickedCurrencyFrom, to: self.pickedCurrencyTo, value: temp))
                            
                            self.us.set(resource.GetDict(), forKey: self.currentResourceName)
                            self.homeVC.viewWillAppear(true)
                            self.view.removeFromSuperview()
                        }))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Error", message:
                            "Insufficient funds!\nCurrently available: " + String(availableAmount) + " " + pickedCurrencyFrom, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message:
                        "Invalid amount!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }

            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        AmountTextField.resignFirstResponder()
        return true
    }
  
}
