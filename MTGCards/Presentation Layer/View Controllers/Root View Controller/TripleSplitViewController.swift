//
//  TripleSplitViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 8/31/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit

class TripleSplitViewController: UIViewController, UISplitViewControllerDelegate {
    
    var split = UISplitViewController(style: .tripleColumn)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        split.primaryBackgroundStyle = .sidebar
//        let sb = CollectionsTableViewController.freshCollectionsList()
        let sb = SidebarCollectionViewController(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .sidebar)))
        split.setViewController(sb, for: .primary)
        split.delegate = self
        
//        let sb2 = CollectionsTableViewController.freshCollectionsList()
        let sb2 = SidebarCollectionViewController(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .sidebarPlain)))
        let nav = UINavigationController()
        nav.title = "Collections"
        nav.viewControllers.append(sb2)
        split.setViewController(nav, for: .compact)
        
        let sup = CardListTableViewController.freshCardList()
        split.setViewController(sup, for: .supplementary)
        
        let sec = PlaceholderViewController.freshPlaceholderController(message: "Select a Card, Deck, or Collection to get started.")
        split.setViewController(sec, for: .secondary)
        
        
        split.show(.primary)
        split.preferredDisplayMode = .twoBesideSecondary
        split.preferredSplitBehavior = .tile
        split.showsSecondaryOnlyButton = false
        split.preferredPrimaryColumnWidthFraction = 0.2
        split.preferredSupplementaryColumnWidthFraction = 0.3
        #if targetEnvironment(macCatalyst)
        split.view.translatesAutoresizingMaskIntoConstraints = false
        #endif
        view.addSubview(split.view)
        #if targetEnvironment(macCatalyst)
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            split.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            split.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            split.view.topAnchor.constraint(equalTo: margins.topAnchor, constant: -30.0),
            split.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        #endif
        //view.addSubview(nav.view)
    }
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "S", modifierFlags: [.control, .shift], action: #selector(self.settings)),
            UIKeyCommand(input: "A", modifierFlags: [.control], action: #selector(self.addButton))
        ]
    }
    @objc func addButton(){
        print("Add Button")
        split.viewController(for: .primary)?.performSelector(onMainThread: #selector(addButton), with: nil, waitUntilDone: false)
        split.viewController(for: .primary)
    }
    @objc func settings(){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.present(settingsVC, animated: true, completion: nil)
        
    }
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
            UserDefaultsHandler.setHasOpened(opened: true)
        }
    }
//    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
//        return .supplementary
//    }
    func splitViewController(_ svc: UISplitViewController,
                             displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        print(proposedDisplayMode.rawValue)
        
        return .twoBesideSecondary
    }
    
}
