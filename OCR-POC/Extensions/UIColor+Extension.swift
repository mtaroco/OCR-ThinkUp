//
//  UIColor+Extension.swift
//
//
//  Created by Mauro Taroco on 9/28/17.
//  Copyright © 2017 Mauro Taroco. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Creates an instance of UIColor based on an RGB value.
    ///
    /// - parameter rgbValue: The Integer representation of the RGB value: Example: 0xFF0000.
    /// - parameter alpha:    The desired alpha for the color.
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Creates an instance of UIColor based on the three RGB value.
    convenience init(red: Int, green: Int, blue: Int, av: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(av))
    }
    
    convenience init(hex: Int, alpha: Float = 1.0) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, av: alpha)
    }
}
