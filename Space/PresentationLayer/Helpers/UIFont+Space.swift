//
//  UIFont+Space.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

let defaultBoldFontName = "Nexa Bold"
let defaultLightFontName = "Nexa Light"

extension UIFont {

  static func defaultBoldFont(ofSize size: Float) -> UIFont {
    let ssize = CGFloat(size)
    return UIFont(name: defaultBoldFontName, size: ssize) ?? UIFont.systemFont(ofSize: ssize)
  }
  
  static func defaultLightFont(ofSize size: Float) -> UIFont {
    let ssize = CGFloat(size)
    return UIFont(name: defaultLightFontName, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: ssize)
  }
    
}
