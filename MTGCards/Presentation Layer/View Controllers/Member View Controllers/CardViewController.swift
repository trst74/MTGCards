//
//  CardViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var jsontextarea: UITextView!
    var card: Card? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let json = try? card?.jsonString(){
            jsontextarea.text = json
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
