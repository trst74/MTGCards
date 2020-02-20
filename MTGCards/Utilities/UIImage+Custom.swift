//
//  UIImage+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 2/20/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit


extension UIImage {
    
   static func resizeImage(image: UIImage?, newWidth: CGFloat) -> UIImage? {
    guard let oldImage = image else {
        return image
    }
        let scale = newWidth / oldImage.size.width
        let newHeight = oldImage.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        oldImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return image }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
