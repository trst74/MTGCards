//
//  DebugViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/8/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    @IBOutlet weak var text: UITextView!
    var json = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = json
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func share(_ sender: Any) {
        shareText(text: json)
    }
    
    func shareText(text: String){
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
