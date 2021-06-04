//
//  FiltersTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/7/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController {
    @IBOutlet weak var wButton: UIButton!
    @IBOutlet weak var uButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var rButton: UIButton!
    @IBOutlet weak var gButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var legalityLabel: UILabel!
    @IBOutlet weak var superTypeLabel: UILabel!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var isPromo: UISwitch!
    @IBOutlet weak var keywordLabel: UILabel!
    
    var searchTableViewController: CardListTableViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applyButton = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyFilters))
        self.navigationItem.setRightBarButton(applyButton, animated: true)
        setCurrentFilters()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilters))
        let flexiableItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(applyFilters))

        if let nav = self.navigationController {
            nav.setToolbarHidden(false, animated: true)
            toolbarItems = [resetButton,flexiableItem, saveButton]
        }
    }
    func setCurrentFilters() {
        if Filters.current.isColorIdentitySelected(color: "W"){
            wButton.setImage(UIImage(named: "W"), for: .normal);
        } else {
            wButton.setImage(UIImage(named: "W60"), for: .normal);
        }
        if Filters.current.isColorIdentitySelected(color: "U"){
            uButton.setImage(UIImage(named: "U"), for: .normal);
        }else {
            uButton.setImage(UIImage(named: "U60"), for: .normal);
        }
        if Filters.current.isColorIdentitySelected(color: "B"){
            bButton.setImage(UIImage(named: "B"), for: .normal);
        }else {
            bButton.setImage(UIImage(named: "B60"), for: .normal);
        }
        if Filters.current.isColorIdentitySelected(color: "R"){
            rButton.setImage(UIImage(named: "R"), for: .normal);
        }else {
            rButton.setImage(UIImage(named: "R60"), for: .normal);
        }
        if Filters.current.isColorIdentitySelected(color: "G"){
            gButton.setImage(UIImage(named: "G"), for: .normal);
        }else {
            gButton.setImage(UIImage(named: "G60"), for: .normal);
        }
        if Filters.current.isColorIdentitySelected(color: "C"){
            cButton.setImage(UIImage(named: "C"), for: .normal);
        }else {
            cButton.setImage(UIImage(named: "C60"), for: .normal);
        }
        typeLabel.text = Filters.current.getSelectedTypesDescription()
        subTypeLabel.text = Filters.current.getSelectedSubtypesDescription()
        superTypeLabel.text = Filters.current.getSelectedSuperTypesDescription()
        legalityLabel.text = Filters.current.getSelectedLegalitiesDescription()
        setLabel.text = Filters.current.getSelectedSetsDescription()
        keywordLabel.text = Filters.current.getSelectedKeywordsDescription()
        isPromo.isOn = Filters.current.isPromoSelected()
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.frame.size.width / 6
        } else {
            return 44
        }
    }
    @objc func applyFilters() {
        if let searchController = searchTableViewController {
            searchController.loadSavedData()
            searchController.updateTitle()
            self.navigationItem.leftBarButtonItem?.title = searchController.title
        }
    }
    @objc func resetFilters() {
        Filters.current.resetFilters()
        applyFilters()
        setCurrentFilters()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "typesFilter" {
            let destination = segue.destination as! TypeFilterTableViewController
            destination.filterController = self
            destination.title = "Types"
        } else if segue.identifier == "legalityFilter" {
            let destination = segue.destination as! LegalityFilterTableViewController
            destination.filterController = self
            destination.title = "Legalities"
        } else if segue.identifier == "subtypeFilter" {
            let destination = segue.destination as! SubTypeFilterTableViewController
            destination.filterController = self
            destination.title = "Sub Type"
        } else if segue.identifier == "supertypeFilter" {
            let destination = segue.destination as! SuperTypeFilterTableViewController
            destination.filterController = self
            destination.title = "Super Type"
        } else if segue.identifier == "setsFilter" {
            let destination = segue.destination as! SetFilterTableViewController
            destination.filterController = self
            destination.title = "Set"
        } else if segue.identifier == "keywordsFilter" {
            let destination = segue.destination as! KeywordFilterTableViewController
            destination.filterController = self
            destination.title = "Keyword"
        }
        
    }
    @IBAction func cButtonClick(_ sender: UIButton) {
        let color = "C"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func gButtonClick(_ sender: UIButton) {
        let color = "G"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func rButtonClick(_ sender: UIButton) {
        let color = "R"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func bButtonClick(_ sender: UIButton) {
        let color = "B"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func uButtonClick(_ sender: UIButton) {
        let color = "U"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func wButtonClick(_ sender: UIButton) {
        let color = "W"
        if Filters.current.isColorIdentitySelected(color: color) {
            sender.setImage(UIImage(named: "\(color)60"), for: .normal);
            Filters.current.deselectColorIdentity(color: color)
        } else {
            sender.setImage(UIImage(named: color), for: .normal);
            Filters.current.selectColorIdentity(color: color)
        }
    }
    @IBAction func isPromoToggled(_ sender: UISwitch) {
        Filters.current.toggleIsPromo()
    }
}
extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
