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
 

}
