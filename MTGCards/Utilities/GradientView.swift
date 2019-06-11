//
//  GradientView.swift
//  Aura
//
//  Created by Egor Sakhabaev on 23.07.17.
//  Copyright © 2017 Egor Sakhabaev. All rights reserved.
//

import UIKit


@IBDesignable
class GradientView: UIView {

    @IBInspectable var colors: [UIColor] = [UIColor.white] {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = colors.map {$0.cgColor}
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint (x: 1, y: 0.5)

    }

}
