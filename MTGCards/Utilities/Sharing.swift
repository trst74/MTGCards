//
//  Sharing.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Sharing {
    static func shareImage(image: UIImage,_ sender: Any?) -> UIActivityViewController{
        let imageToShare = [ image ]
        let activityController = UIActivityViewController(activityItems: imageToShare,
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        activityController.popoverPresentationController?.sourceView = sender as? UIView
        return activityController
    }
    static func shareText(text: String,_ sender: Any?) -> UIActivityViewController{
        let activityController = UIActivityViewController(activityItems: [text],
                                                          applicationActivities: nil)
        // if the action is sent from a bar button item
        activityController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        // if the action is sent from some other kind of UIView (a table cell or button)
        activityController.popoverPresentationController?.sourceView = sender as? UIView
        return activityController
    }
    static func shareUrl(url: URL, _ sender: Any?) -> UIActivityViewController{
        let items = [url]
        let activityController = UIActivityViewController(activityItems: items,
                                                          applicationActivities: nil)
        // if the action is sent from a bar button item
        activityController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        // if the action is sent from some other kind of UIView (a table cell or button)
        activityController.popoverPresentationController?.sourceView = sender as? UIView
        return activityController
    }
    static func presentAddToDeckMenu(id: NSManagedObjectID, sourceView: UITableViewCell?) -> UIAlertController{
        let alert = UIAlertController(title: "Add To Deck...", message: nil, preferredStyle: .actionSheet)
        let decks = DataManager.getDecksFromCoreData()
        for d in decks {
            alert.addAction(UIAlertAction(title: d.name ?? "", style: .default, handler: { action in
                DataManager.addCardToDeck(deckId: d.objectID, cardId: id)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
            popoverController.sourceView = sourceView
        }
        return alert
    }
}
