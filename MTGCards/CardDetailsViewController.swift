//
//  CardDetailsViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/26/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var colorIdentity: UILabel!
    @IBOutlet weak var manaCost: UILabel!
    @IBOutlet weak var power: UILabel!
    @IBOutlet weak var toughness: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var rulingsView: UIView!
    @IBOutlet weak var legalitiesView: UIView!
    
    @IBOutlet weak var rulingsTitle: UILabel!
    @IBOutlet weak var legalitiesTitle: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var legalitiesHeightConstraint: NSLayoutConstraint!
    
    var currentCard:CDCard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentCard?.name
        update(with: nil, Key: "")
        
        if let imagecode = currentCard?.set?.magicCardsInfoCode {
            loadImage(imagecode: imagecode)
        } else {
            let imagecode = (currentCard?.set?.code?.lowercased())!
            loadImage(imagecode: imagecode)
            
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        cardImage.isUserInteractionEnabled = true
        cardImage.addGestureRecognizer(longPressRecognizer)
        
        if (currentCard?.rulings?.count)! < 1 {
            heightConstraint.constant = 0
            rulingsView.isHidden = true
        } else {
            var height = rulingsTitle.frame.height
            if let rulings = currentCard?.rulings{
                if let rs = rulings as? Set<CDRuling>{
                    
                    var firstView: CardRulingsView? = nil
                    
                    let rls =  rs.sorted(by: {$0.date?.compare($1.date! as Date) == .orderedDescending})
                    
                    for ruling in rls {
                        let viewFromNib = Bundle.main.loadNibNamed("CardRulingView", owner: self, options: nil)?[0] as! CardRulingsView
                        let df = DateFormatter()
                        df.dateStyle = .short
                        viewFromNib.rulingDate.text = df.string(from: ruling.date! as Date)
                        //                        var fontHeight: CGFloat = 0.0
                        //                        if let font = viewFromNib.rulingText.font {
                        //                            fontHeight = font.lineHeight
                        //                        }
                        viewFromNib.rulingText.text = ruling.text
                        //viewFromNib.rulingText.attributedText = getAttributedString(text: ruling.text!, height: Int(fontHeight))
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
                                constant: 8
                        ))
                        rulingsView.addConstraint(
                            NSLayoutConstraint(
                                item: viewFromNib,
                                attribute: .trailing,
                                relatedBy: .equal,
                                toItem: rulingsView,
                                attribute: .trailing,
                                multiplier: 1.0,
                                constant: -8
                        ))
                        firstView = viewFromNib
                        viewFromNib.layoutIfNeeded()
                        height += (8 + viewFromNib.frame.height)
                    }
                    
                }
            }
            
            rulingsView.sizeToFit()
            heightConstraint.constant = height
        }
        //legalities
        if (currentCard?.legalities?.count)! < 1 {
            legalitiesHeightConstraint.constant = 0
            legalitiesView.isHidden = true
        } else {
            var legalitiesHeight = legalitiesTitle.frame.height
            if let legalities = currentCard?.legalities{
                if let ls = legalities as? Set<CDLegaility>{
                    
                    let lgs = ls.sorted(by: {$0.format! < $1.format!})
                    
                    var firstView: CardLegalityView? = nil
                    for legality in lgs {
                        let viewFromNib = Bundle.main.loadNibNamed("CardLegalityView", owner: self, options: nil)?[0] as! CardLegalityView
                        viewFromNib.formatText.text = legality.format!+":"
                        viewFromNib.legalityText.text = legality.legality
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
                                constant: 8
                        ))
                        legalitiesView.addConstraint(
                            NSLayoutConstraint(
                                item: viewFromNib,
                                attribute: .trailing,
                                relatedBy: .equal,
                                toItem: legalitiesView,
                                attribute: .trailing,
                                multiplier: 1.0,
                                constant: -8
                        ))
                        firstView = viewFromNib
                        viewFromNib.layoutIfNeeded()
                        legalitiesHeight += (8 + viewFromNib.frame.height)
                    }
                    
                }
            }
            
            legalitiesView.sizeToFit()
            legalitiesHeightConstraint.constant = legalitiesHeight
        }
        
        
        
        detailsView.layoutIfNeeded()
        
        //colorIdentity.text = (currentCard?.colorIdentity as? [String]).map({$0})?.joined(separator: ", ")
        //manaCost.text = currentCard?.cmc.description
        //power.text = currentCard?.power
        //toughness.text = currentCard?.toughness
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func longPressed(sender: UILongPressGestureRecognizer)  {
        if sender.state != .ended {
            return
        }
        share()
    }
    
    func share() {
        // image to share
        let image = self.cardImage.image
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func loadImage(imagecode: String){
        print("imagecode: \(imagecode)")
        var mci = ""
        if let number = currentCard?.number {
            mci = number
        }
        else if let mciNumber = currentCard?.mciNumber {
            mci = mciNumber
        }
        print("MCI: \(mci)")
        var image = getImage(Key: imagecode+mci)
        if image != nil {
            cardImage.image = image
        } else {
            var imageurl = "https://magiccards.info/scans/en/" + imagecode + "/" + mci + ".jpg"
            print(imageurl)
            if let code = currentCard?.set?.code {
                let scryfallUrl = "https://img.scryfall.com/cards/large/en/\(code)/\(mci).jpg"
                print(scryfallUrl)
            }

            let checkedUrl = URL(string: imageurl)
            cardImage.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl!, Key: imagecode+mci)
        }
    }
    
    
    func downloadImage(url: URL, Key: String) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.cardImage.bounds.origin = CGPoint.zero
                self.update(with: image, Key: Key)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func update(with image: UIImage?, Key: String) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            cardImage.image = imageToDisplay
            saveImage(image: imageToDisplay, Key: Key)
        } else {
            spinner.startAnimating()
            cardImage.image = nil
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveImage(image: UIImage, Key: String) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            print(filename)
            try? data.write(to: filename)
        }
    }
    func getImage(Key: String) -> UIImage?{
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            print("loaded from cache")
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    func getAttributedString(text: String, height: Int) -> NSAttributedString {
        
        var endString = NSMutableAttributedString(string: text)
        
        let image1Attachment = NSTextAttachment()
        var oneImage = UIImage(named: "1.png")
        
        image1Attachment.image = oneImage
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        let range = endString.mutableString.range(of: "{1}")
        endString.replaceCharacters(in: range, with: image1String)
        
        return endString
    }
    
}

