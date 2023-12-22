//
//  AddResourceViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/28/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class AddResourceViewController: UIViewController, UITextFieldDelegate {

    let us = UserDefaults.standard
    
    @IBOutlet weak var BackButton: UIBarButtonItem!
    var homeVC = HomeViewController()
    var isAPopUp:Bool = false
    var resourcesVC = ResourceTableViewController()
    var resourceName = ""
    var pickedMainCurrency = "Currency"
    var pickedFirstCurrency = "Currency"
    var pickedSecondCurrency = "Currency"
    var pickedThirdCurrency = "Currency"
    @IBOutlet weak var ResourceNameTextField: UITextField!
    @IBOutlet weak var MainCurrencyLabel: UILabel!
    @IBOutlet weak var SecondCurrencyLabel: UILabel!
    @IBOutlet weak var ThirdCurrencyLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.ResourceNameTextField.delegate = self
        MainCurrencyLabel.text = pickedMainCurrency
        SecondCurrencyLabel.text = pickedSecondCurrency
        ThirdCurrencyLabel.text = pickedThirdCurrency
        
        if(isAPopUp == true)
        {
            self.BackButton.isEnabled = false
        }
    }
    
    @IBAction func pickMainCurrencyPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        if var temp = us.array(forKey: "currencies") as? [String]
        {
            if(pickedSecondCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedSecondCurrency)!)
            }
            if(pickedThirdCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedThirdCurrency)!)
            }
            pickerPopUpVC.arrayForPickerView = temp
            pickerPopUpVC.selected = temp[0]
            pickerPopUpVC.kind = "addResource"
            pickerPopUpVC.type = "main"
        }
        
        pickerPopUpVC.addResourceVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    @IBAction func pickSecondCurrencyPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        if var temp = us.array(forKey: "currencies") as? [String]
        {
            if(pickedMainCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedMainCurrency)!)
            }
            if(pickedThirdCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedThirdCurrency)!)
            }
            pickerPopUpVC.selected = temp[0]
            pickerPopUpVC.arrayForPickerView = temp
            pickerPopUpVC.kind = "addResource"
            pickerPopUpVC.type = "second"
        }
        
        pickerPopUpVC.addResourceVC = self
        pickerPopUpVC.viewWillAppear(true)
    }
    
    @IBAction func pickThirdCurrencyPressed(_ sender: UIButton)
    {
        let pickerPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "pickerPopUpID") as! PickerPopUpViewController
        self.addChild(pickerPopUpVC)
        pickerPopUpVC.view.frame = self.view.frame
        self.view.addSubview(pickerPopUpVC.view)
        pickerPopUpVC.didMove(toParent: self)
        
        if var temp = us.array(forKey: "currencies") as? [String]
        {
            if(pickedMainCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedMainCurrency)!)
            }
            if(pickedSecondCurrency != "Currency")
            {
                temp.remove(at: temp.firstIndex(of: pickedSecondCurrency)!)
            }
            pickerPopUpVC.selected = temp[0]
            pickerPopUpVC.arrayForPickerView = temp
            pickerPopUpVC.kind = "addResource"
            pickerPopUpVC.type = "third"
        }
        
        pickerPopUpVC.addResourceVC = self
        pickerPopUpVC.viewWillAppear(true)
        
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem)
    {
        if(ResourceNameTextField.text! == "")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please enter a name!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(pickedMainCurrency == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please pick a main currency!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(pickedSecondCurrency == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please pick a second currency!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if(pickedThirdCurrency == "Currency")
        {
            let alertController = UIAlertController(title: "Error", message:
                "Please pick a third currency!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
        else if(ResourceNameTextField.text!.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil)
        {
            resourceName = ResourceNameTextField.text!
            
            let resource = Resource(name: resourceName, firstCurrency: pickedFirstCurrency, secondCurrency: pickedSecondCurrency, thirdCurrency: pickedThirdCurrency)
            
            if var temp = us.array(forKey: "resources") as? [String]
            {
                temp.append(resourceName)
                us.set(temp, forKey: "resources")
//                us.set(resourceName, forKey: "currentResourceName")
            }
            
            us.set(resource.GetDict(), forKey: resourceName)
            
            if(isAPopUp == true)
            {
                us.set(resourceName, forKey: "currentResourceName")
                self.view.removeFromSuperview()
                homeVC.viewWillAppear(true)
            }
            else
            {
                resourcesVC.viewWillAppear(true)
                dismiss(animated: true, completion: nil)
                
                

            }   
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message:
                "Resource name must not contain a number!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        ResourceNameTextField.resignFirstResponder()
        return true
    }
    
    
}
