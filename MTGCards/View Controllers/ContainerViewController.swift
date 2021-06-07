//
//  ContainerViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/2/21.
//

import UIKit
import CoreData

class ContainerViewController: UIViewController, UISplitViewControllerDelegate {
    let split = UISplitViewController(style: .tripleColumn)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(split)
        self.view.addSubview(split.view)
        split.view.frame = self.view.bounds
        split.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        split.didMove(toParent: self)
        split.primaryBackgroundStyle = .sidebar
        
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .supplementary
        config.footerMode = .none
        let list =  UICollectionViewCompositionalLayout.list(using: config)
        let sb = SidebarCollectionViewController(collectionViewLayout: list)
        
        split.setViewController(sb, for: .primary)
        split.delegate = self
        
        var config2 = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config2.headerMode = .supplementary
        config2.footerMode = .none
        let list2 =  UICollectionViewCompositionalLayout.list(using: config2)
        let sb2 = SidebarCollectionViewController(collectionViewLayout: list2)
        let nav = UINavigationController()
        nav.title = "Collections"
        nav.viewControllers.append(sb2)
        split.setViewController(nav, for: .compact)
        
        let sup = CardListTableViewController.freshCardList()
        split.setViewController(sup, for: .supplementary)
        
        let sec = PlaceholderViewController.freshPlaceholderController(message: "Select a Card, Deck, or Collection to get started.")
        split.setViewController(sec, for: .secondary)
        
        #if targetEnvironment(macCatalyst)
        split.preferredDisplayMode = .twoBesideSecondary
        #else
        split.preferredDisplayMode = .oneBesideSecondary
        #endif
        split.preferredSplitBehavior = .tile
        split.showsSecondaryOnlyButton = false
        split.preferredPrimaryColumnWidthFraction = 0.2
        split.preferredSupplementaryColumnWidthFraction = 0.3
        // Do any additional setup after loading the view.
    }
    override var keyCommands: [UIKeyCommand]? {
        return [
            
            UIKeyCommand(title: "Settings", image: nil, action: #selector(self.settings), input: "S", modifierFlags: [.control, .shift], propertyList: nil, alternates: [], discoverabilityTitle: "Settings", attributes: [], state: .on),
            UIKeyCommand(title: "Add...", image: nil, action: #selector(self.addButton), input: "A", modifierFlags: [.control], propertyList: nil, alternates: [], discoverabilityTitle: "Add...", attributes: [], state: .on)
        ]
    }
    @objc func addButton(){
        split.viewController(for: .primary)?.performSelector(onMainThread: #selector(addButton), with: nil, waitUntilDone: false)
    }
    @objc func settings(){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.present(settingsVC, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultsHandler.isFirstTimeOpening(){
            //onbarding
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            guard let pageOne = storyboard.instantiateInitialViewController() as? OnboardingPageViewController else {
                fatalError("Error going to settings")
            }
            pageOne.modalPresentationStyle = .fullScreen
            self.present(pageOne, animated: true, completion: nil)
            //create collection and wish list
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "high")
            
            guard  let entity = NSEntityDescription.entity(forEntityName: "Collection", in:  CoreDataStack.handler.privateContext) else {
                fatalError("Failed to decode Card")
            }
            let collection = Collection.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
            collection.name = "Collection"
            collection.uuid = UUID()
            let wishlist = Collection.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
            wishlist.name = "Wish List"
            wishlist.uuid = UUID()
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch  {
                print(error)
            }
            UserDefaultsHandler.setExcludeOnlineOnly(exclude: true)
            UserDefaultsHandler.setHasOpened(opened: true)
        }
    }

}
