//
//  SceneDelegate.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/1/21.
//

import UIKit
import CoreData
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var toolbarDelegate = ToolbarDelegate()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
     
        
//        if #available(iOS 14, *) {
//            if window?.traitCollection.userInterfaceIdiom == .pad {
//                let splitViewController = TripleSplitViewController()
//                window?.rootViewController = splitViewController
//
//            }
//        }
//
        #if targetEnvironment(macCatalyst)
        guard let windowScene = scene as? UIWindowScene else { return }

        let toolbar = NSToolbar(identifier: "main")
        toolbar.delegate = toolbarDelegate
        toolbar.displayMode = .iconOnly

        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar?.isVisible = false
            titlebar.toolbar = nil
        }
        #endif
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.banner,.sound])
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        maybeOpenedFromWidget(urlContexts: URLContexts)
    }
    
    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>) {
        #if targetEnvironment(macCatalyst)
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        #endif
        guard let context: UIOpenURLContext = urlContexts.first else { return }
        guard let components = NSURLComponents(url: context.url, resolvingAgainstBaseURL: true), let params = components.queryItems else { return }
        if let source = params.first(where: {$0.name == "source"})?.value {
            if source == "cardArtWidget" {
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
                                #if targetEnvironment(macCatalyst)
                                if let t = keyWindow?.rootViewController as? TripleSplitViewController {
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
                                #else
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
                                #endif
                            }
                        }
                    } catch {
                        print(error)
                        card = nil
                    }
                }
            }
            
            print("🚀 Launched from widget")
        }
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MTGCards")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

