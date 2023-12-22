//
//  PickerPopUpViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/12/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class PickerPopUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let us = UserDefaults.standard
    var selected = ""
    var arrayForPickerView:[String] = []
    var type = ""
    var kind = ""
    var addTransactionVC:AddTransactionViewController = AddTransactionViewController()
    var transferVC:TransferPopUpViewController = TransferPopUpViewController()
    var exchangeVC:ExchangePopUpViewController = ExchangePopUpViewController()
    var addResourceVC:AddResourceViewController = AddResourceViewController()
    @IBOutlet weak var PickerView: UIPickerView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.PickerView.dataSource = self
        self.PickerView.delegate = self
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton)
    {
        switch kind
        {
        case "transfer":
            if(type == "resources")
            {
                transferVC.pickedResource = selected
            }
            if(type == "currencies")
            {
                transferVC.pickedCurrency = selected
            }
            
            self.view.removeFromSuperview()
            
            transferVC.viewDidLoad()
            break
            
        case "exchange":
            if(type == "from")
            {
                exchangeVC.pickedCurrencyFrom = selected
            }
            if(type == "to")
            {
                exchangeVC.pickedCurrencyTo = selected
            }
            
            self.view.removeFromSuperview()
            exchangeVC.viewDidLoad()
            break
            
        case "addResource":
            if(type == "main")
            {
                addResourceVC.pickedMainCurrency = selected
                addResourceVC.pickedFirstCurrency = selected
            }
            if(type == "second")
            {
                addResourceVC.pickedSecondCurrency = selected
            }
            if(type == "third")
            {
                addResourceVC.pickedThirdCurrency = selected
            }
            self.view.removeFromSuperview()
            addResourceVC.viewWillAppear(true)
            break
            
        case "addTransaction":
            if(type == "currency")
            {
                addTransactionVC.currentCurrency = selected
            }
            if(type == "resource")
            {
                addTransactionVC.currentResourceName = selected
            }
            self.view.removeFromSuperview()
            addTransactionVC.viewDidLoad()
            break
        default:
            break
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayForPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayForPickerView[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = arrayForPickerView[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
