//
//  TransactionViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 6/18/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    
    @IBOutlet weak var ResourceLabel: UILabel!
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var CommentTextView: UITextView!
    
    var transaction:Transaction = Transaction()

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        ResourceLabel.text = transaction.resourceName
        AmountLabel.text = String(transaction.value)
        CurrencyLabel.text = transaction.currency
        
        if(transaction.type == TransactionType.deposit)
        {
            AmountLabel.textColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        }
        else
        {
            AmountLabel.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        
        CommentTextView.text = transaction.comment
        CommentTextView.isEditable = false
    }
    
    
    
    @IBAction func DonePressed(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
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
