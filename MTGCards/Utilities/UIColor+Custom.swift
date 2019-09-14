//
//  UIColor+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 2/2/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

extension UIColor {
    struct Identity {
        static let Plains = UIColor(named: "Plains") ?? UIColor.white
        static let Islands = UIColor(named: "Islands") ?? UIColor.white
        static let Swamps = UIColor(named: "Swamps") ?? UIColor.white
        static let Mountains = UIColor(named: "Mountains") ?? UIColor.white
        static let Forests = UIColor(named: "Forests") ?? UIColor.white
        static let Artifacts = UIColor(named: "Artifacts") ?? UIColor.white
        static let Lands = UIColor(named: "Lands") ?? UIColor.white
    }
}
