//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-16.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // print path to realm db
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // print path for user defaults file
        print("DB: \n")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true))

        // Create new realm module and write to db
        do {
            _ = try Realm()

        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        // commit current state of realm
        
        return true
    }

}

