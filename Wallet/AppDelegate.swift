//
//  AppDelegate.swift
//  Wallet
//
//  Created by Milan Zezelj on 4/6/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let us = UserDefaults.standard
        
        if us.object(forKey: "firstStart") == nil
        {
            let currencies = ["RSD", "EUR", "USD", "GBP"]
            us.set(currencies, forKey: "currencies")
            
            us.set("Resource", forKey: "pickedResource")
            us.set("Currency", forKey: "pickedCurrency")
            us.set(Currency.getRates(), forKey: "rates")
            us.set(currencies, forKey: "currencies")
            let resources = ["Wallet"]
            us.set(resources, forKey: "resources")

            us.set(resources[0], forKey: "currentResourceName")
            let wallet = Resource(name: "Wallet", imageName: "Wallet", firstCurrency: "RSD", secondCurrency: "EUR", thirdCurrency: "USD")
            us.set(wallet.GetDict(), forKey: wallet.name)
            
            us.set(true, forKey: "firstStart")
        }

        

        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

