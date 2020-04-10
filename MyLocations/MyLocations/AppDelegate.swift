//
//  AppDelegate.swift
//  MyLocations
//
//  Created by Catalina on 3/14/20.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        customizeAppearance()
        if #available(iOS 13, *){
            return false
        } else {
        let tabController = window!.rootViewController as! UITabBarController
        if let tabViewControllers = tabController.viewControllers{
            // Tag Tab
            var navController = tabViewControllers[0] as! UINavigationController
            let controller1 = navController.viewControllers.first as! CurrentLocationViewController
            controller1.managedObjectContext = managedObjectContext
            
            // Location Tab
            navController = tabViewControllers[1] as! UINavigationController
            let controller2 = navController.viewControllers.first as! LocationsViewController
            controller2.managedObjectContext = managedObjectContext
            let _ = controller2.view
            
            navController = tabViewControllers[2] as! UINavigationController
            let controller3 = navController.viewControllers.first as! MapViewController
            controller3.managedObjectContext = managedObjectContext
        }
        listenForFatalCoreDataNotifications()
        return true
        }
    }

    // MARK: UISceneSession Lifecycle

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK:- Customize Appearance:
    func customizeAppearance () {
        UINavigationBar.appearance().barTintColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITabBar.appearance().barTintColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.systemYellow
    }

    //MARK:- Helper Methods:
    func listenForFatalCoreDataNotifications(){
        //1.
        NotificationCenter.default.addObserver(
            forName: CoreDataSaveFailedNotification,
            object: nil, queue: OperationQueue.main, using: {
                notification in
                //2
                let message = """
                    There was a fatal error in the app and it cannot continue.
                    Press OK to terminate the app. Sorry for the inconvenience.
                    """
                //3
                let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
                //4
                let action = UIAlertAction(title: "OK", style: .default){_ in
                    let exception = NSException(
                        name: NSExceptionName.internalInconsistencyException,
                        reason: "Fatal Core Data Error", userInfo: nil)
                    exception.raise()
                }
                alert.addAction(action)
                //5
                let tabController = self.window!.rootViewController!
                tabController.present(alert, animated: true, completion: nil)
        })
    }

}

