//
//  ResourceTableViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/8/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit


class ResourceTableViewController: UITableViewController {
    
    
    @IBOutlet var TableViewList: UITableView!
    
    let us = UserDefaults.standard
    var resources = [""]
    var selectedResource:Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        self.title = "Resources"
        resources = us.array(forKey: "resources") as! [String]
        TableViewList.reloadData()
        print("Ucitan ResourceTabVC")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
        cell.textLabel?.text = resources[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        
        us.set(resources[i], forKey: "currentResourceName")
        tabBarController?.selectedIndex = 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            us.removeObject(forKey: resources[indexPath.row])
            resources.remove(at: indexPath.row)
            TableViewList.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if(resources.count > 0)
            {
                us.set(resources[0], forKey: "currentResourceName")
                us.set(resources, forKey: "resources")
            }
            else
            {
                us.set("", forKey: "currentResourceName")
                us.set(resources, forKey: "resources")
            }
            
            
        }
    }
    
    
}
