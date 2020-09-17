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
    
    // get a complementary color to this color
    // https://gist.github.com/klein-artur/025a0fa4f167a648d9ea
    var complementary: UIColor {
        
        let ciColor = CIColor(color: self)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: ciColor.alpha)
    }
    
    // perceptive luminance
    // https://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color
    var contrast: UIColor {
        
        let ciColor = CIColor(color: self)
        
        let compRed: CGFloat = ciColor.red * 0.299
        let compGreen: CGFloat = ciColor.green * 0.587
        let compBlue: CGFloat = ciColor.blue * 0.114
        
        // Counting the perceptive luminance - human eye favors green color...
        let luminance = (compRed + compGreen + compBlue)
        
        // bright colors - black font
        // dark colors - white font
        let col: CGFloat = luminance < 0.55 ? 0 : 1
        
        return UIColor( red: col, green: col, blue: col, alpha: ciColor.alpha)
    }
    
    func contrast(threshold: CGFloat = 0.65, bright: UIColor = .white, dark: UIColor = .black) -> UIColor {
        
        let ciColor = CIColor(color: self)
        
        let compRed = 0.299 * ciColor.red
        let compGreen = 0.587 * ciColor.green
        let compBlue = 0.114 * ciColor.blue
        
        // Counting the perceptive luminance - human eye favors green color...
        let luminance = (compRed + compGreen + compBlue)
        //let rounded = CGFloat( round(1000 * luminance) / 1000 )
        return luminance < threshold ? dark : bright
    }
}
