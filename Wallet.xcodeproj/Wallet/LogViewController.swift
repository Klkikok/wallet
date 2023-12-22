//
//  LogViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 6/19/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    let us = UserDefaults.standard
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    
    @IBAction func ClearButtonPressed(_ sender: UIButton)
    {
        
        let alertController = UIAlertController(title: "Confirmation", message:
            "Are you sure you want to delete the log?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler:
            { action in
                let transactions = Array<Dictionary<String, String>>()
                self.us.set(transactions, forKey: "transactions")
                
                globalLogTVC.viewWillAppear(true)
        }))
        self.present(alertController, animated: true, completion: nil)
       
        
    }
    
}
