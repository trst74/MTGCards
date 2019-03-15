//
//  CardViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var powerToughnessLabel: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var pricesView: UIView!
    
    var shareButton: UIBarButtonItem?
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share))
        self.navigationItem.setRightBarButton(shareButton, animated: true)
        
        costLabel.attributedText = card?.manaCost?.replaceSymbols()
        typeLabel.text = card?.type
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
            TcgPlayerApi.handler.getPrices(for: cardid) { prices in
                var resultString = "Market:"
                if let market = prices.results.first(where: {$0.subTypeName == "Normal" })?.marketPrice{
                    resultString += " N - \(market.currencyUS)"
                }
                if let fmarket = prices.results.first(where: {$0.subTypeName == "Foil" })?.marketPrice {
                    resultString += " F - \(fmarket.currencyUS)"
                }
                self.marketPrice.text = resultString
                if resultString == "Market:" {
                    
                }
                
            }
        }
        loadImage()
        let taps = UITapGestureRecognizer(target: self, action: #selector(showDebug))
        taps.numberOfTapsRequired = 10
        taps.delegate = self
        cardImage.addGestureRecognizer(taps)
    }
    @objc func showDebug(){
        print("debug")
        let storyboard = UIStoryboard(name: "Debug", bundle: nil)
        guard let debugVC = storyboard.instantiateInitialViewController() as? DebugViewController else {
            fatalError("Error going to settings")
        }
        if let json = try? card?.jsonString() {
            debugVC.json = json ?? ""
            //self.navigationController?.pushViewController(settingsVC, animated: true)
            self.present(debugVC, animated: true, completion: nil)
        }
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
            if card?.side == "b" {
                key += "b"
            }
            let image = getImage(Key: key)
            if image != nil {
                cardImage.image = image
            } else {
                if let id = card?.scryfallID {
                    do {
                        var url = "https://api.scryfall.com/cards/\(id)?format=image"
                        if card?.side == "b" {
                            url += "&face=back"
                        }
                        if  let imageURL = URL(string: url) {
                            cardImage.contentMode = .scaleAspectFit
                            downloadImage(url: imageURL, Key: key)
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
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareText(text: String){
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareUrl(url: URL, popupView: AnyObject?){
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [SafariActivity()])
        if let location = popupView {
            activityViewController.popoverPresentationController?.sourceView = location.view
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        }
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension CardViewController {
    static func refreshCardController(s: Card) -> CardViewController {
        let storyboard = UIStoryboard(name: "Card", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CardViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        filelist.title = s.name
        filelist.card = s
        
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
