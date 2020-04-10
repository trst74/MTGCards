//
//  PageOneViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class PageOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pagetwo" {
            let destination = segue.destination as? PageTwoViewController
            destination?.pageOne = self
        }
    }
    @IBAction func next(_ sender: Any) {
        if let pageViewController = self.parent as? OnboardingPageViewController {
            pageViewController.setViewControllers([pageViewController.pages[1]], direction: .forward, animated: true, completion: nil)
        }
    }
    

}
