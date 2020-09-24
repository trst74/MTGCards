//
//  DeckCardQuantityTableViewCell.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/14/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class DeckCardQuantityTableViewCell: UITableViewCell, UITextFieldDelegate {


    @IBOutlet weak var quantity: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quantity.delegate = self
        quantity.addDoneButtonToKeyboard(myAction:  #selector(self.quantity.resignFirstResponder))
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }

}
