//
//  LogTableViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/8/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

var globalLogTVC = LogTableViewController()
class LogTableViewController: UITableViewController {

    @IBOutlet var TableViewList: UITableView!
    let us = UserDefaults.standard
    var transactions = [Transaction]()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        if let temp = us.array(forKey: "transactions") as? [Dictionary<String, String>]
        {
            transactions = Transaction.getArray(dict: temp)
        }
        TableViewList.reloadData()
        print(transactions.count)
        globalLogTVC = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogTableViewCell

        cell.ResourceLabel.text = transactions[indexPath.row].resourceName
        cell.AmountLabel.text =  String(transactions[indexPath.row].value) + " " + transactions[indexPath.row].currency
        if(transactions[indexPath.row].type == TransactionType.deposit)
        {
            cell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
        }
        else
        {
            cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7)
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        
        let TransactionPopUp = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "viewTransactionID") as! TransactionViewController
        TransactionPopUp.transaction = transactions[i]
        self.addChild(TransactionPopUp)
        TransactionPopUp.view.frame = self.view.frame
        self.view.addSubview(TransactionPopUp.view)
        TransactionPopUp.didMove(toParent: self)
        
        
    }
    

//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if editingStyle == UITableViewCell.EditingStyle.delete
//        {
//            if let temp = us.array(forKey: "transactions") as? [Dictionary<String, String>]
//            {
//                let temp1 = Transaction.getArray(dict: temp)
//                
//                
//            }
//            
//        }
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


