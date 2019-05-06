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

extension RootViewController {
    func freshSplitViewTemplate() -> UISplitViewController {
        let split = UISplitViewController()
        split.preferredDisplayMode = .allVisible
        let navigation = UINavigationController()
        navigation.navigationBar.prefersLargeTitles = false
        navigation.navigationItem.largeTitleDisplayMode = .never
        split.viewControllers = [navigation]
        return split
    }
    func primaryNavigation(_ split: UISplitViewController)
        -> UINavigationController {
            guard let nav = split.viewControllers.first
                as? UINavigationController else {
                    fatalError("Project config error - primary view doesn't have Navigation")
            }
            nav.navigationBar.prefersLargeTitles = false
            nav.navigationItem.largeTitleDisplayMode = .never
            return nav
    }
}

extension RootViewController {
    func freshFileLevelPlaceholder() -> PlaceholderViewController {
        let placeholder = PlaceholderViewController.freshPlaceholderController(message: "Select Card. Swipe left to delete")
        return placeholder
    }

    func freshFolderLevelPlaceholder() -> PlaceholderViewController {
        let placeholder = PlaceholderViewController.freshPlaceholderController(message: "Select Collection or create. Swipe left to delete or swipe right to rename")
        return placeholder
    }
}

extension RootViewController {
    func rootFileList(_ split: UISplitViewController) -> UIViewController? {
        let navigation = primaryNavigation(split)
        if let fileList = navigation.viewControllers.first as? DeckTableViewController {
            return fileList
        }
        if let fileList = navigation.viewControllers.first as? CardListTableViewController {
            return fileList
        }
        if let fileList = navigation.viewControllers.first as? CollectionTableViewController {
            return fileList
        }
        return nil
    

    }

    func activeEditor(_ split: UISplitViewController) -> CardViewController? {
        guard let navigation = split.viewControllers.last as? UINavigationController,
            let editor = navigation.viewControllers.first as? CardViewController else {
                return nil
        }
        return editor
    }
}
