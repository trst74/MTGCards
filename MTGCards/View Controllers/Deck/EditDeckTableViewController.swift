//
//  EditDeckTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/18/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit

class EditDeckTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var deck: Deck?
    var collectionsViewController: SidebarCollectionViewController?
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var deckName: UITextField!
    @IBOutlet weak var formatPicker: UIPickerView!
    
    var formats = ["","Standard","Historic","Pioneer","Modern","Legacy", "Vintage","Commander","Frontier","Pauper","Penny","Duel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatPicker.delegate = self
        self.formatPicker.dataSource = self
        if let name = deck?.name {
            self.deckName.text = name
        }
        if let format = deck?.format {
      
            formatPicker.selectRow(formats.firstIndex(of: format) ?? 0, inComponent: 0, animated: true)
        }
        tableView.tableFooterView = UIView()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        deck?.name = deckName.text
        deck?.format = formats[formatPicker.selectedRow(inComponent: 0)]
        
           do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
        self.collectionsViewController?.createDataSource()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formats.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return formats[row]
    }
}
