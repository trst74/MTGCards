//
//  CardViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
import CoreServices
import SwiftUI

class CardViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardImageAspect: NSLayoutConstraint!
    @IBOutlet weak var cardImageHeight: NSLayoutConstraint!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var powerToughnessLabel: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var pricesView: UIView!
    @IBOutlet weak var rulingsView: UIView!
    @IBOutlet weak var rulingsHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var rulingsTitle: UILabel!
    @IBOutlet weak var legalitiesView: UIView!
    @IBOutlet weak var legalitiesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var legalitiesTitle: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var pricesRootStack: UIStackView!
    @IBOutlet weak var pricesErrorMessage: UILabel!
    
    @IBOutlet weak var normalStackView: UIStackView!
    @IBOutlet weak var normalLow: UILabel!
    @IBOutlet weak var normalMid: UILabel!
    @IBOutlet weak var normalMarket: UILabel!
    
    @IBOutlet weak var foilStackView: UIStackView!
    @IBOutlet weak var foilLow: UILabel!
    @IBOutlet weak var foilMid: UILabel!
    @IBOutlet weak var foilMarket: UILabel!
    
    var shareButton: UIBarButtonItem?
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share))
        self.navigationItem.setRightBarButton(shareButton, animated: true)
        
        costLabel.attributedText = card?.manaCost?.replaceSymbols()
        typeLabel.text = card?.type
        if let setname = card?.set.name, let rarity = card?.rarity?.capitalized {
            setLabel.text = "\(setname) - \(rarity)"
        }
        textLabel.attributedText = card?.text?.replaceSymbols()
        if let reserved = card?.isReserved, reserved {
            otherLabel.text = "Reserved"
        } else {
            otherLabel.text = ""
        }
        artistLabel.text = card?.artist
        if let power = card?.power, let toughness = card?.toughness {
            powerToughnessLabel.text = "\(power)/\(toughness)"
        } else {
            powerToughnessLabel.text = ""
        }
        if let cardid = card?.tcgplayerProductID, cardid > 0 {
            TcgPlayerApi.handler.getPrices(for: [cardid]) { prices in
                if let normal = prices.results.first(where: {$0.subTypeName == "Normal" }) {
                    self.normalLow.text = normal.lowPrice?.currencyUS ?? "--"
                    self.normalMid.text = normal.midPrice?.currencyUS ?? "--"
                    self.normalMarket.text = normal.marketPrice?.currencyUS ?? "--"
                }
                if !(self.card?.hasNonFoil ?? true) {
                    self.normalStackView.isHidden = true
                }
                if let foil = prices.results.first(where: {$0.subTypeName == "Foil" }) {
                    self.foilMarket.text = foil.marketPrice?.currencyUS ?? "--"
                    self.foilLow.text = foil.lowPrice?.currencyUS ?? "--"
                    self.foilMid.text = foil.midPrice?.currencyUS ?? "--"
                }
                if !(self.card?.hasFoil ?? true) {
                    self.foilStackView.isHidden = true
                }
            }
        } else {
            self.pricesErrorMessage.isHidden = false
            self.pricesRootStack.isHidden = true
            self.pricesView.layoutSubviews()
        }
        loadImage()
        
        let taps = UITapGestureRecognizer(target: self, action: #selector(showDebug))
        taps.numberOfTapsRequired = 10
        taps.delegate = self
        cardImage.addGestureRecognizer(taps)
        detailsView.layer.cornerRadius = 10
        pricesView.layer.cornerRadius = 10
        cardImage.layer.cornerRadius = 15
        cardImage.clipsToBounds = true
        if #available(iOS 13.0, *) {
            textLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadRulings()
        loadLegalities()
        scrollview.layoutSubviews()
        scrollview.layoutIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        loadRulings()
        loadLegalities()
    }
    @objc func showDebug(){
        print("debug")
//        let storyboard = UIStoryboard(name: "Debug", bundle: nil)
//        guard let debugVC = storyboard.instantiateInitialViewController() as? DebugViewController else {
//            fatalError("Error going to settings")
//        }
//        if let json = ((try? card?.jsonString()) as String??) {
//            debugVC.json = json ?? ""
//            //self.navigationController?.pushViewController(settingsVC, animated: true)
//            self.present(debugVC, animated: true, completion: nil)
//        }
//        let cardView = CardView(card: card)
//        let viewCtrl = UIHostingController(rootView: cardView)
//        self.present(viewCtrl, animated: true, completion: nil)
    }
    @objc func share(){
        let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { action in
            self.shareImage()
        }))
        if let multiverseid = card?.multiverseID, multiverseid > 0 {
            alert.addAction(UIAlertAction(title: "Gatherer", style: .default, handler: { action in
                if let url = URL(string:  "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=\(multiverseid)"){
                    self.shareUrl(url: url, popupView: self.shareButton)
                }
            }))
        }
        if let tcg = card?.tcgplayerPurchaseURL {
            alert.addAction(UIAlertAction(title: "TCGPlayer", style: .default, handler: { action in
                self.shareText(text: tcg)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            self.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = shareButton
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadImage() {
        if var key = card?.uuid {
            if card?.side == "b" && card?.layout != "adventure"{
                key += "b"
            }
            let image = getImage(Key: key)
            if image != nil {
                cardImage.image = image
            } else {
                if let id = card?.scryfallID {
                    do {
                        let version = UserDefaultsHandler.selectedCardImageQuality()
                        if version != "none" {
                            var url = "https://api.scryfall.com/cards/\(id)?format=image&version=\(version)"
                            if card?.side == "b" && card?.layout != "split" && card?.layout != "flip" && card?.layout != "meld" && card?.layout != "adventure"{
                                url += "&face=back"
                            }
                            if  let imageURL = URL(string: url) {
                                cardImage.contentMode = .scaleAspectFit
                                downloadImage(url: imageURL, Key: key)
                            }
                        } else {
                            cardImage.isHidden = true
                            cardImageAspect.isActive = false
                            
                        }
                    }
                }
            }
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveImage(image: UIImage, Key: String) {
        if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            print(filename)
            try? data.write(to: filename)
        }
    }
    func getImage(Key: String) -> UIImage? {
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            print("loaded from cache")
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    func downloadImage(url: URL, Key: String) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, _, error)  in
            guard let data = data, error == nil else {
                return
                
            }
            print("Download Finished")
            DispatchQueue.main.async { () -> Void in
                let image = UIImage(data: data)
                self.cardImage.bounds.origin = CGPoint.zero
                if let imageToDisplay = image {
                    self.cardImage.image = imageToDisplay
                    self.saveImage(image: imageToDisplay, Key: Key)
                    if let c = self.card, let uuid = c.uuid {
                        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                        attributeSet.title = c.name
                        attributeSet.contentDescription = c.set.name
                        attributeSet.thumbnailData = data
                        let item = CSSearchableItem(uniqueIdentifier: "\(uuid)", domainIdentifier: "com.roboticsnailsoftware.MTGCollection", attributeSet: attributeSet)
                        CSSearchableIndex.default().indexSearchableItems([item]) { error in
                            if let error = error {
                                print("Indexing error: \(error.localizedDescription)")
                            } else {
                                print("Search item successfully indexed!")
                            }
                        }
                        print("item created \(c.name)")
                    }
                }
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    @IBAction func imageLongPressed(_ sender: UILongPressGestureRecognizer) {
        shareImage()
    }
    func shareImage(){
        let image = self.cardImage.image
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareText(text: String){
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareUrl(url: URL, popupView: AnyObject?){
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [SafariActivity()])
        if let location = popupView {
            activityViewController.popoverPresentationController?.sourceView = location.view
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    func loadLegalities(){
        if let legalities = card?.legalities
        {
            var legalitiesHeight = legalitiesTitle.frame.height
            let legalities = legalities.getLegalitiesCollection()
            var firstView: CardLegalityView? = nil
            for legality in legalities {
                let viewFromNib = Bundle.main.loadNibNamed("CardLegalityView", owner: self, options: nil)?[0] as! CardLegalityView
                viewFromNib.formatText.text = legality.format+":"
                //viewFromNib.legalityText.text = legality.legality
                viewFromNib.legality = legality.legality
                viewFromNib.layer.cornerRadius = 10
                viewFromNib.clipsToBounds = true
                viewFromNib.translatesAutoresizingMaskIntoConstraints = false
                legalitiesView.addSubview(viewFromNib)
                if firstView != nil {
                    legalitiesView.addConstraint(
                        NSLayoutConstraint(
                            item: viewFromNib,
                            attribute: .top,
                            relatedBy: .equal,
                            toItem: firstView,
                            attribute: .bottom,
                            multiplier: 1.0,
                            constant: 8
                    ))
                } else {
                    legalitiesView.addConstraint(
                        NSLayoutConstraint(
                            item: viewFromNib,
                            attribute: .top,
                            relatedBy: .equal,
                            toItem: legalitiesTitle,
                            attribute: .bottom,
                            multiplier: 1.0,
                            constant: 8
                    ))
                }
                legalitiesView.addConstraint(
                    NSLayoutConstraint(
                        item: viewFromNib,
                        attribute: .leading,
                        relatedBy: .equal,
                        toItem: legalitiesView,
                        attribute: .leading,
                        multiplier: 1.0,
                        constant: 0
                ))
                legalitiesView.addConstraint(
                    NSLayoutConstraint(
                        item: viewFromNib,
                        attribute: .trailing,
                        relatedBy: .equal,
                        toItem: legalitiesView,
                        attribute: .trailing,
                        multiplier: 1.0,
                        constant: 0
                ))
                firstView = viewFromNib
                viewFromNib.layoutIfNeeded()
                legalitiesHeight += (8 + viewFromNib.frame.height)
            }
            legalitiesView.sizeToFit()
            legalitiesHeightConstraint.constant = legalitiesHeight
            
        } else {
            legalitiesHeightConstraint.constant = 0
            legalitiesView.isHidden = true
        }
    }
    func loadRulings(){
        if card?.rulings.count ?? 0 < 1 {
            rulingsHeightContstraint.constant = 0
            rulingsView.isHidden = true
        } else {
            var rulingsHeight = rulingsTitle.frame.height
            if let rulings = card?.rulings{
                if let rs = rulings.allObjects as? [Ruling] {
                    
                    var firstView: CardRulingsView? = nil
                    
                    let rls =  rs.sorted(by: {
                        let d0 = $0.date?.toDate()
                        let d1 = $1.date?.toDate()
                        if let d1 = d1 {
                            return d0?.compare(d1) == .orderedDescending
                        }
                        return false
                    })
                    
                    for ruling in rls {
                        let viewFromNib = Bundle.main.loadNibNamed("CardRulingView", owner: self, options: nil)?[0] as! CardRulingsView
                        let df = DateFormatter()
                        df.dateStyle = .short
                        if let date = ruling.date?.toDate() {
                            viewFromNib.rulingDate.text = df.string(from: date)
                            viewFromNib.rulingText.attributedText = ruling.text?.replaceSymbols()
                            viewFromNib.layer.cornerRadius = 10
                            viewFromNib.clipsToBounds = true
                            viewFromNib.translatesAutoresizingMaskIntoConstraints = false
                            rulingsView.addSubview(viewFromNib)
                            if firstView != nil {
                                rulingsView.addConstraint(
                                    NSLayoutConstraint(
                                        item: viewFromNib,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: firstView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: 8
                                ))
                            } else {
                                rulingsView.addConstraint(
                                    NSLayoutConstraint(
                                        item: viewFromNib,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: rulingsTitle,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: 8
                                ))
                                
                            }
                            rulingsView.addConstraint(
                                NSLayoutConstraint(
                                    item: viewFromNib,
                                    attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: rulingsView,
                                    attribute: .leading,
                                    multiplier: 1.0,
                                    constant: 0
                            ))
                            rulingsView.addConstraint(
                                NSLayoutConstraint(
                                    item: viewFromNib,
                                    attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: rulingsView,
                                    attribute: .trailing,
                                    multiplier: 1.0,
                                    constant: 0
                            ))
                            firstView = viewFromNib
                            viewFromNib.layoutIfNeeded()
                            rulingsHeight += (8 + viewFromNib.frame.height)
                        }
                    }
                }
            }
            rulingsView.sizeToFit()
            rulingsHeightContstraint.constant = rulingsHeight
        }
    }
}
extension CardViewController {
    static func refreshCardController(id: NSManagedObjectID) -> CardViewController {
        let storyboard = UIStoryboard(name: "Card", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CardViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        if let s = CoreDataStack.handler.privateContext.object(with: id) as? Card {
            filelist.title = s.name
            filelist.card = s
        }
        return filelist
    }
}
extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        numberStyle = style
    }
}
extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let currencyUS = NumberFormatter(style: .currency, locale: .us)
    static let currencyBR = NumberFormatter(style: .currency, locale: .br)
}
extension Numeric {   // for Swift 3 use FloatingPoint or Int
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
    var currencyUS: String {
        return Formatter.currencyUS.string(for: self) ?? ""
    }
    var currencyBR: String {
        return Formatter.currencyBR.string(for: self) ?? ""
    }
}
extension Locale {
    static let br = Locale(identifier: "pt_BR")
    static let us = Locale(identifier: "en_US")
    static let uk = Locale(identifier: "en_UK")
}

