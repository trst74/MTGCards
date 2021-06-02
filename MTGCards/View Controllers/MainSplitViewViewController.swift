//
//  MainSplitViewViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/1/21.
//

import UIKit

class MainSplitViewViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
     
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.splitViewController?.primaryBackgroundStyle = .sidebar
        
    
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.headerMode = .supplementary
        config.footerMode = .none
        let list =  UICollectionViewCompositionalLayout.list(using: config)
        let sb = SidebarCollectionViewController(collectionViewLayout: list)
        // Do any additional setup after loading the view.
        splitViewController?.setViewController(sb, for: .primary)
        
        let sec = PlaceholderViewController.freshPlaceholderController(message: "Select a Card, Deck, or Collection to get started.")
        splitViewController?.setViewController(sec, for: .secondary)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
