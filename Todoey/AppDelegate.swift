//
//  AppDelegate.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-11.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - Locate realm File
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //MARK: - Initialise a New Realm
        do {
            let _ = try Realm()
            
        } catch  {
            print("Error initialising new realm, \(error)")
        }
        
        
        return true
    }

    

    


}

