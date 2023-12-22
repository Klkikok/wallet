//
//  HomeViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/8/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

var globalHomeVC : HomeViewController?

class HomeViewController: UIViewController {

    @IBOutlet weak var ResourceTitle: UINavigationItem!
    var currentResourceName:String = "Select a source"
    var currentResource:Resource = Resource()
    var currentCurrencies = [""]
    var currentImageName = ""
    @IBOutlet weak var ResourceTypeImageView: UIImageView!
    @IBOutlet weak var MainCurrencyLabel: UILabel!
    @IBOutlet weak var FirstCurrencyLabel: UILabel!
    @IBOutlet weak var SecondCurrencyLabel: UILabel!
    @IBOutlet weak var ThirdCurrencyLabel: UILabel!
    
    var currentMainCurrency = "Select a source"
    var currentFirstCurrency = ""
    var currentSecondCurrency = ""
    var currentThirdCurrency = ""
    
    var currentMainCurrencyValue:Double = 0
    var currentFirstCurrencyValue:Double = 0
    var currentSecondCurrencyValue:Double = 0
    var currentThirdCurrencyValue:Double = 0
    
    let us = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        if let temp = us.string(forKey: "currentResourceName")
        {
            currentResourceName = temp
        }
        
        print(currentResourceName)
        
        if(currentResourceName == "")
        {
            let addResourcePopUp = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "addResourceID") as! AddResourceViewController
            self.addChild(addResourcePopUp)
            addResourcePopUp.view.frame = self.view.frame
            self.view.addSubview(addResourcePopUp.view)
            addResourcePopUp.didMove(toParent: self)
            addResourcePopUp.isAPopUp = true
            addResourcePopUp.homeVC = self
            self.title = "Home"
            
            let alertController = UIAlertController(title: "Error", message:
                "No resources! Please add one!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            ResourceTitle.title = currentResourceName
            self.title = currentResourceName
            
            if let temp:Dictionary<String, String> = us.dictionary(forKey: currentResourceName) as? Dictionary<String, String>
            {
                self.currentResource = Resource(dict: temp)
                self.currentImageName = currentResource.imageName
                self.currentMainCurrency = currentResource.mainCurrency
                self.currentMainCurrencyValue = currentResource.mainCurrencyValue
                self.currentFirstCurrency = currentResource.otherCurrencies[0].name
                self.currentFirstCurrencyValue = currentResource.otherCurrencies[0].value
                self.currentSecondCurrency = currentResource.otherCurrencies[1].name
                self.currentSecondCurrencyValue = currentResource.otherCurrencies[1].value
                self.currentThirdCurrency = currentResource.otherCurrencies[2].name
                self.currentThirdCurrencyValue = currentResource.otherCurrencies[2].value
                
                self.currentCurrencies = [currentMainCurrency, currentSecondCurrency, currentThirdCurrency];
            }
            ResourceTypeImageView.image = UIImage(named: currentImageName)
            MainCurrencyLabel.text = String(currentMainCurrency) + " " + String(EvaluateMainCurrencyValue())
            FirstCurrencyLabel.text = currentFirstCurrency + " " + String(currentFirstCurrencyValue)
            SecondCurrencyLabel.text = currentSecondCurrency + " " + String(currentSecondCurrencyValue)
            ThirdCurrencyLabel.text = currentThirdCurrency + " " + String(currentThirdCurrencyValue)
        }
        
        print("Ucitan HomeVC")
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        let temp = currentResource.GetDict()
        us.set(temp, forKey: currentResourceName)
        us.set(currentResourceName, forKey: "currentResourceName")
        
        super.viewWillDisappear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        let temp = currentResource.GetDict()
        us.set(temp, forKey: currentResourceName)
        us.set(currentResourceName, forKey: "currentResourceName")
        
        super.viewDidDisappear(true)
    }

    func EvaluateMainCurrencyValue() -> Double
    {
        return Double(round(1000 * (Currency.Exchange(from: currentFirstCurrency, to: currentMainCurrency, value: currentFirstCurrencyValue) + Currency.Exchange(from: currentSecondCurrency, to: currentMainCurrency, value: currentSecondCurrencyValue) + Currency.Exchange(from: currentThirdCurrency, to: currentMainCurrency, value: currentThirdCurrencyValue))) / 1000)
    }
    
    func FindCurrency(currency: String) -> Int
    {
        if(currentCurrencies.contains(currency))
        {
            return currentCurrencies.firstIndex(of: currency)!
        }
        else
        {
            return -1
        }
    }
    
    @IBAction func transferButtonPressed(_ sender: UIButton)
    {
        if let temp = us.array(forKey: "resources") as? [String]
        {
            if temp.count > 1
            {
                let transferPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "transferPopUpID") as! TransferPopUpViewController
                self.addChild(transferPopUpVC)
                transferPopUpVC.view.frame = self.view.frame
                self.view.addSubview(transferPopUpVC.view)
                transferPopUpVC.didMove(toParent: self)
                transferPopUpVC.currentResourceName = currentResourceName
                transferPopUpVC.homeVC = self
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message:
                    "There is no other resource you can transfer to!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func exchangeButtonPressed(_ sender: UIButton)
    {
        let exchangePopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "exchangePopUpID") as! ExchangePopUpViewController
        self.addChild(exchangePopUpVC)
        exchangePopUpVC.view.frame = self.view.frame
        self.view.addSubview(exchangePopUpVC.view)
        exchangePopUpVC.didMove(toParent: self)
        exchangePopUpVC.currentResourceName = currentResourceName
        exchangePopUpVC.homeVC = self
    }
    
    
    @IBAction func AddTransactionPlusPressed(_ sender: UIButton)
    {
        let addTransactionPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "addTransactionID") as! AddTransactionViewController
        
        addTransactionPopUpVC.transactionType = "deposit"
        
        self.addChild(addTransactionPopUpVC)
        addTransactionPopUpVC.view.frame = self.view.frame
        self.view.addSubview(addTransactionPopUpVC.view)
        addTransactionPopUpVC.didMove(toParent: self)
        
        addTransactionPopUpVC.homeVC = self
    }
    
    @IBAction func AddTransactionMinusPressed(_ sender: UIButton)
    {
        let addTransactionPopUpVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "addTransactionID") as! AddTransactionViewController
        
        addTransactionPopUpVC.transactionType = "withdraw"
        
        self.addChild(addTransactionPopUpVC)
        addTransactionPopUpVC.view.frame = self.view.frame
        self.view.addSubview(addTransactionPopUpVC.view)
        addTransactionPopUpVC.didMove(toParent: self)
        
        addTransactionPopUpVC.homeVC = self
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
