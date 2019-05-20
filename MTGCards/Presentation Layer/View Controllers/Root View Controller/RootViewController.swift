/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

extension UIViewController {
    var isHorizontallyRegular: Bool {
        return traitCollection.horizontalSizeClass == .regular
    }
}

class RootViewController: UIViewController {
    enum NavigationStackCompact: Int {
        case foldersOnly = 1
        case foldersFiles = 2
        case foldersFilesEditor = 3
    }
    
    let rootSplitSmallFraction: CGFloat = 0.25
    let rootSplitLargeFraction: CGFloat = 0.40
    
    lazy var rootSplitView: UISplitViewController = {
        let split = freshSplitViewTemplate()
        split.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
        split.delegate = self
        return split
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DataManager.getSetList()
        
        
        
        StateCoordinator.shared.delegate = self
        installRootSplit()
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultsHandler.isFirstTimeOpening(){
            //onbarding
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            guard let pageOne = storyboard.instantiateInitialViewController() as? PageOneViewController else {
                fatalError("Error going to settings")
            }
            //self.navigationController?.pushViewController(settingsVC, animated: true)
            self.present(pageOne, animated: true, completion: nil)
            //create collection and wish list
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "high")
            UserDefaultsHandler.setHasOpened(opened: true)
        }
    }
    func installDoubleSplitWhenHorizontallyRegular() -> UISplitViewController? {
        guard isHorizontallyRegular else {
            return nil
        }
        
        if let subSplit = rootSplitView.viewControllers.last
            as? UISplitViewController {
            return subSplit
        }
        
        let split = freshSplitViewTemplate()
        split.delegate = self
        rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitSmallFraction
        rootSplitView.showDetailViewController(split, sender: self)
        return split
    }
    
    func targetSplitForCurrentTraitCollection() -> UISplitViewController {
        if isHorizontallyRegular {
            guard let subSplit = installDoubleSplitWhenHorizontallyRegular() else {
                fatalError("you must have a UISplitViewController here")
            }
            return subSplit
        } else {
            return rootSplitView
        }
    }
    
    func installRootSplit() {
        view.addSubview(rootSplitView.view)
        view.pinToInside(rootSplitView.view)
        addChild(rootSplitView)
        
        let fileList = CollectionsTableViewController.freshCollectionsList()
        let navigation = primaryNavigation(rootSplitView)
        navigation.viewControllers = [fileList]
        navigation.delegate = self
    }
}

extension RootViewController: StateCoordinatorDelegate {
    func gotoState(_ nextState: SelectionState, s: AnyObject?) {
        
        
        if nextState == .cardSelected {
            if let id = s as? NSManagedObjectID {
                gotoCardSelected(id: id)
            }
        } else if nextState == .deckSelected {
            if let deck = s as? NSManagedObjectID {
                gotoDeckSelected(deck: deck)
            }
        } else if nextState == .toolSelected {
            if let tool = s as? String{
                gotoToolSelected(name: tool)
            }
        } else if nextState == .collectionSelected {
            if let collection = s as? NSManagedObjectID {
                gotoCollectionSelected(s: collection)
            }
        }
    }
    
    
    func gotoCollectionSelected(s: NSManagedObjectID) {
        let collectionVC = CollectionTableViewController.freshCollection(collection: s)
        installCollection(collection: collectionVC)
    }
    
    func gotoCardSelected(id: NSManagedObjectID) {
        let cardDetails = CardViewController.refreshCardController(id: id)
        let navigation = freshNavigationController(rootViewController: cardDetails)
        targetSplitForCurrentTraitCollection().showDetailViewController(navigation, sender: self)
        
    }
    func gotoDeckSelected(deck: NSManagedObjectID) {
        let decklist = DeckTableViewController.freshDeck(deck: deck)
        installDeck(deck: decklist)
        
    }
    func gotoToolSelected(name: String) {
        if name == "Search" {
            let cardList = CardListTableViewController.freshCardList()
            
            cardList.title = name
            installFileList(fileList: cardList)
        }
    }
    //    //4
    func freshNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.prefersLargeTitles = false
        nav.navigationItem.largeTitleDisplayMode = .never
        return nav
    }
}

extension RootViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        //1
        let primaryNav = primaryNavigation(splitViewController)
        var currentStack = primaryNav.viewControllers
        
        //2
        if let secondarySplit = secondaryViewController as? UISplitViewController {
            //2.1
            if let fileList = rootFileList(secondarySplit) {
                currentStack.append(fileList)
            }
            //2.2
            if let editor = activeEditor(secondarySplit) {
                currentStack.append(editor)
            }
            //2.3
            primaryNav.viewControllers = currentStack
            return true
            
        } else if let folderList = currentStack.first {
            //3
            primaryNav.viewControllers = [folderList]
            return true
            
        }
        return false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             separateSecondaryFrom primaryViewController: UIViewController)
        -> UIViewController? {
            
            guard let primaryNavigation = primaryViewController as? UINavigationController else {
                return nil
            }
            primaryNavigation.navigationBar.prefersLargeTitles = false
            primaryNavigation.navigationItem.largeTitleDisplayMode = .never
            return decomposeStackForTransitionToRegular(primaryNavigation)
    }
    
    func decomposeStackForTransitionToRegular(_ navigationController: UINavigationController) -> UIViewController? {
        //1
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationItem.largeTitleDisplayMode = .never
        let controllerStack = navigationController.viewControllers
        guard let folders = controllerStack.first else {
            return nil
        }
        
        //2
        defer {
            navigationController.viewControllers = [folders]
            rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitSmallFraction
        }
        
        //3
        if navigationStack(navigationController, isAt: .foldersOnly) {
            //folder list only was presented  - return a placeholder
            return freshFolderLevelPlaceholder()
            
        } else if navigationStack(navigationController, isAt: .foldersFiles) {
            //folders and file list was presented  - return a split with files + placeholder
            let filesAndPlaceholder = configuredSplit(first: controllerStack[1], second: freshFileLevelPlaceholder())
            return filesAndPlaceholder
            
        } else if navigationStack(navigationController, isAt: .foldersFilesEditor) {
            //folders, files and editor was presented  - return a split with files + editor
            let filesAndEditor = configuredSplit(first: controllerStack[1], second: controllerStack[2])
            return filesAndEditor
        }
        
        return nil
    }
    
    func configuredSplit(first: UIViewController, second: UIViewController)
        -> UIViewController {
            let freshSplit = freshSplitViewTemplate()
            freshSplit.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
            let fileNavigation = primaryNavigation(freshSplit)
            fileNavigation.viewControllers = [first]
            freshSplit.viewControllers = [fileNavigation, second]
            return freshSplit
    }
}

extension RootViewController {
    func showFileLevelPlaceholder(in targetSplit: UISplitViewController) {
        if isHorizontallyRegular {
            targetSplit.showDetailViewController(freshFileLevelPlaceholder(), sender: self)
        }
    }
    
    func showFolderLevelPlaceholder(in targetSplit: UISplitViewController) {
        if isHorizontallyRegular {
            rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
            targetSplit.showDetailViewController(freshFolderLevelPlaceholder(), sender: self)
        }
    }
    
    func installFileList(fileList: CardListTableViewController) {
        if isHorizontallyRegular,
            let subSplit = installDoubleSplitWhenHorizontallyRegular() {
            //1
            let navigation = primaryNavigation(subSplit)
            navigation.viewControllers = [fileList]
            //2
            subSplit.preferredDisplayMode = .allVisible
            subSplit.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
            rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitSmallFraction
            //3
            showFileLevelPlaceholder(in: subSplit)
        } else {
            let navigation = primaryNavigation(rootSplitView)
            navigation.pushViewController(fileList, animated: true)
        }
    }
    func installDeck(deck: DeckTableViewController) {
        if isHorizontallyRegular,
            let subSplit = installDoubleSplitWhenHorizontallyRegular() {
            //1
            let navigation = primaryNavigation(subSplit)
            navigation.viewControllers = [deck]
            //2
            subSplit.preferredDisplayMode = .allVisible
            subSplit.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
            rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitSmallFraction
            //3
            showFileLevelPlaceholder(in: subSplit)
        } else {
            let navigation = primaryNavigation(rootSplitView)
            navigation.pushViewController(deck, animated: true)
        }
    }
    func installCollection(collection: CollectionTableViewController) {
        if isHorizontallyRegular,
            let subSplit = installDoubleSplitWhenHorizontallyRegular() {
            //1
            let navigation = primaryNavigation(subSplit)
            navigation.viewControllers = [collection]
            //2
            subSplit.preferredDisplayMode = .allVisible
            subSplit.preferredPrimaryColumnWidthFraction = rootSplitLargeFraction
            rootSplitView.preferredPrimaryColumnWidthFraction = rootSplitSmallFraction
            //3
            showFileLevelPlaceholder(in: subSplit)
        } else {
            let navigation = primaryNavigation(rootSplitView)
            navigation.pushViewController(collection, animated: true)
        }
    }
}

extension RootViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationStack(navigationController, isAt: .foldersOnly) {
            showFolderLevelPlaceholder(in: rootSplitView)
        }
    }
    
    func navigationStack(_ navigation: UINavigationController, isAt state: NavigationStackCompact) -> Bool {
        let count = navigation.viewControllers.count
        if let value = NavigationStackCompact(rawValue: count) {
            return value == state
        }
        return false
    }
}
