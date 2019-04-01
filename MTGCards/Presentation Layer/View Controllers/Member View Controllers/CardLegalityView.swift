//
//  CardLegalityView.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/30/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit

@IBDesignable
class CardLegalityView: UIView {

    @IBOutlet weak var formatText: UILabel!
    @IBOutlet weak var legalityText: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public var legality: String = "" {
        didSet {
            if legality == "Legal" {
                self.backgroundColor = UIColor.Identity.Forests
                
            } else if legality == "Banned" {
                self.backgroundColor = UIColor.Identity.Mountains
            } else if legality == "Restricted" {
                self.backgroundColor = UIColor.Identity.Islands
            } else {
                self.backgroundColor = UIColor.lightGray
            }
            legalityText.text = legality
        }
   
    }
}
