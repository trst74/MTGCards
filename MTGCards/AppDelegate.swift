//
//  AppDelegate.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
import SwiftUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        // Override point for customization after application launch.
        UINavigationBar.appearance().prefersLargeTitles = false
        if let windowScene = self.window?.windowScene {
                        #if targetEnvironment(macCatalyst)
                        if let titlebar = windowScene.titlebar {
                            titlebar.titleVisibility = .hidden
                            titlebar.toolbar?.isVisible = false
                            titlebar.toolbar = nil
                        }
                        #endif
        }
        return true
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        
        builder.remove(menu: .services)
        builder.remove(menu: .format)
        builder.remove(menu: .toolbar)
        
        let addCommand  = UIKeyCommand(input: "A", modifierFlags: [.control], action: #selector(self.add))
        addCommand.title = "Add..."
        let addMenu = UIMenu(title: "Add...", image: nil, identifier: UIMenu.Identifier("add"), options: .displayInline, children: [addCommand])
        builder.insertChild(addMenu, atStartOfMenu: .file)
        
        let settingsCommand = UIKeyCommand(input: "S", modifierFlags: [.control, .shift], action: #selector(self.settings))
        settingsCommand.title = "Settings"
        let settingsMenu = UIMenu(title: "Settings", image: nil, identifier: UIMenu.Identifier("settings"), options: .displayInline, children: [settingsCommand])
        builder.insertSibling(settingsMenu, afterMenu: addMenu.identifier)
        
                
        
   
    }
    @objc func add(){

        var vc = self.window?.rootViewController as? TripleSplitViewController
        vc?.addButton()
    }
    @objc func settings(){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.window?.rootViewController?.present(settingsVC, animated: true, completion: nil)
        
    }
    @IBAction func showHelp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.roboticsnailsoftware.com")!)
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                print(uniqueIdentifier)
                var card: Card?
                let request = NSFetchRequest<Card>(entityName: "Card")
                request.predicate = NSPredicate(format: "uuid == %@", uniqueIdentifier)
                do {
                    let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
                    if results.count > 1 {
                        print("Too many items with uuid \(uniqueIdentifier)")
                    } else {
                        card = results[0]
                    }
                } catch {
                    print(error)
                    card = nil
                }
                if let id = card?.objectID {
                    
                    if self.window?.traitCollection.horizontalSizeClass == .regular {
                        StateCoordinator.shared.didSelectTool(tool: "Search")
                    }
                    StateCoordinator.shared.didSelectCard(id: id)
                }
            }
        }
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let params = components.queryItems else {
            print("Invalid URL or album path missing")
            return false
        }
        if let scryfallID = params.first(where: { $0.name == "scryfallID" })?.value {
            var card: Card?
            let request = NSFetchRequest<Card>(entityName: "Card")
            request.predicate = NSPredicate(format: "scryfallID == %@", scryfallID)
            do {
                let results = try CoreDataStack.handler.privateContext.fetch(request)
                if results.count > 1 {
                    print("Too many items with uuid \(scryfallID)")
                } else if results.count < 1 {
                } else {
                    card = results[0]
                    if let card = card {
                        if let t = self.window?.rootViewController as? TripleSplitViewController {
                            if !(t.split.traitCollection.horizontalSizeClass == .regular) {
                                let vc = UIHostingController(rootView: CardVC(card: card))
                                let nav = t.split.viewController(for: .compact) as? UINavigationController
                                nav?.pushViewController(vc, animated: true)
                                
                            } else {
                                t.split.setViewController(nil, for: .secondary)
                                let vc = UIHostingController(rootView: CardVC(card: card))
                                t.split.setViewController(vc, for: .secondary)
                            }
                        }
                    }
                }
            } catch {
                print(error)
                card = nil
            }
            return true
        } else {
            print("param missing")
            return false
        }
    }
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        if userActivityType == "com.apple.corespotlightitem" {
            return true
        }
        return false
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MTGCards")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.banner,.sound])
    }
}
