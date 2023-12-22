//
//  ResourceViewController.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/28/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController {
    
    var resourceTVC = ResourceTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        resourceTVC.viewWillAppear(true)
    }
    
    @IBAction func addResourceButton(_ sender: Any) {
        performSegue(withIdentifier: "addResourceSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addResourceSegue"
        {
            let vc = segue.destination as! AddResourceViewController
            vc.resourcesVC = resourceTVC
        }
        else if segue.identifier == "showResourceTVCSegue"
        {
            resourceTVC = segue.destination as! ResourceTableViewController
        }
        
    }
    
}
