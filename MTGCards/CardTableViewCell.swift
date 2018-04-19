//
//  CardTableViewCell.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/26/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    var gradientLayer: CAGradientLayer? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
