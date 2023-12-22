//
//  TransferPopUpViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/12/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class TransferPopUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var AvailableAmountLabel: UILabel!
    var availableAmount:Double = -1
    var currentResourceName = ""
    var homeVC = HomeViewController() 
    var pickedResource = "Resource"
    var pickedCurrency = "Currency"
    var pickedAmount:Double = 0
    @IBOutlet weak var PickedResourceLabel: UILabel!
    @IBOutlet weak var PickedCurrencyLabel: UILabel!
    @IBOutlet weak var AmountTextField: UITextField!
    
    var us = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmountTextField.delegate = self
        PickedResourceLabel.text = pickedResource
        PickedCurrencyLabel.text = pickedCurrency
        if(pickedCurrency != "Currency")
        {
            let index = homeVC.FindCurrency(currency: pickedCurrency)
            
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
    
    @IBAction func cancelPressed(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
    }
    @IBAction func donePressed(_ sender: UIButton)
    {
        if(pickedResource == "Resource")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a resource!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(pickedCurrency == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please select a currency!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let resourceFrom = Resource(dict: us.dictionary(forKey: currentResourceName) as! Dictionary<String, String>)
            let resourceTo = Resource(dict: us.dictionary(forKey: pickedResource) as! Dictionary<String, String>)
            
            if(AmountTextField.text! == "")
            {
                let alertController = UIAlertController(title: "Error", message:
                    "Please enter the amount!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            else if let temp = Double(AmountTextField.text!)
            {
                if(resourceFrom.HasCurrency(currency: pickedCurrency) && resourceTo.HasCurrency(currency: pickedCurrency))
                {
                    
                    let indexFrom = resourceFrom.FindCurrency(currency: pickedCurrency)
                    let indexTo = resourceTo.FindCurrency(currency: pickedCurrency)
                    if(temp <= resourceFrom.otherCurrencies[indexFrom].value)
                    {
                        let alertController = UIAlertController(title: "Confirmation", message:
                            "Are you sure you want to do this transfer?", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
                        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                        { action in
                            resourceFrom.RemoveAtIndex(from: indexFrom, value: temp)
                            resourceTo.AddAtIndex(dest: indexTo, value: temp)
                            self.us.set(resourceFrom.GetDict(), forKey: self.currentResourceName)
                            self.us.set(resourceTo.GetDict(), forKey: self.pickedResource)
                            self.homeVC.viewWillAppear(true)
                            self.view.removeFromSuperview()
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Error", message:
                            "Insufficient funds!\nCurrently available: " + String(availableAmount) + " " + pickedCurrency, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
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
    
    @IBAction func pickResourseButtonPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        if let temp = us.array(forKey: "resources") as? [String]
        {
            pickerPopUpVC.arrayForPickerView = temp
            pickerPopUpVC.arrayForPickerView.remove(at: temp.firstIndex(of: currentResourceName)!)
            pickerPopUpVC.selected = pickerPopUpVC.arrayForPickerView[0]
            pickerPopUpVC.kind = "transfer"
            pickerPopUpVC.type = "resources"
        }
        
        pickerPopUpVC.transferVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    @IBAction func pickCurrencyButtonPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        pickerPopUpVC.arrayForPickerView = homeVC.currentCurrencies
        pickerPopUpVC.selected = homeVC.currentCurrencies[0]
        pickerPopUpVC.kind = "transfer"
        pickerPopUpVC.type = "currencies"
        
        pickerPopUpVC.transferVC = self
        pickerPopUpVC.viewWillAppear(true)
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
