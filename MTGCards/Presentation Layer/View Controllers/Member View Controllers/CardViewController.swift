//
//  CardViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var powerToughnessLabel: UILabel!
    
    var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
        costLabel.text = card?.manaCost
        typeLabel.text = card?.type
        textLabel.text = card?.text
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
        loadImage()
        
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func loadImage() {
        if let key = card?.uuid {
            let image = getImage(Key: key)
            if image != nil {
                cardImage.image = image
            } else {
                if let id = card?.scryfallID, let url = URL(string: "https://api.scryfall.com/cards/\(id)") {
                    print(url)
                    let sfc = try? ScryfallCard.init(fromURL: url)
                    if let largestring = sfc?.imageUris?.large, let imageURL = URL(string: largestring) {
                        cardImage.contentMode = .scaleAspectFit
                        downloadImage(url: imageURL, Key: key)
                    } else if let faces = sfc?.cardFaces {
                        let face = faces.first(where: { $0.name == card?.name})
                        if let largestring = face?.imageUris.large, let imageURL = URL(string: largestring) {
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
        let image = self.cardImage.image
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
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
