//
//  DeckCardQuantityTableViewCell.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/14/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class DeckCardQuantityTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func quantityStepper(_ sender: UIStepper) {
        quantityLabel.text = "\(Int(sender.value))"
    }
}
