//
//  UIView+Extension.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/13/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: Background View Extensions
     
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setDarkMode(view: UIView) {
        view.overrideUserInterfaceStyle = .dark
    }

    //MARK: Image Extensions
    
    func photoImageView(imageView: UIImageView) {
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 4
//        imageView.layer.borderColor = Colors.mainBlue.cgColor
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 4.0
        
    }
    
    func photoButtonView(imageView: UIButton) {
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = Colors.mainBlue.cgColor
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 4.0
        
    }
    
    
}


