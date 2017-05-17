//
//  UIColor+Space.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import Foundation

typealias HexNumber = UInt32

extension UIColor {
  class func transparentGrey() -> UIColor {
    return UIColor.rgba(0, g: 0, b: 0, a: 0.3)
  }
    
  class func spaceBlueColor() -> UIColor {
    return UIColor.rgbHex(0x0C96FD)
  }
}

extension UIColor {
  class func rgbHex(_ hexValue: HexNumber) -> UIColor { // 0xb5b5b5
    let redComp   = CGFloat(Double((hexValue & 0xFF0000) >> 16) / 255.0)
    let greenComp = CGFloat(Double((hexValue & 0x00FF00) >>  8) / 255.0)
    let blueComp  = CGFloat(Double((hexValue & 0x0000FF)      ) / 255.0)
    let alphaComp = 1.0 as CGFloat
    return UIColor(red: redComp, green: greenComp, blue: blueComp, alpha: alphaComp)
  }
  
  class func rgba(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
  }
}
