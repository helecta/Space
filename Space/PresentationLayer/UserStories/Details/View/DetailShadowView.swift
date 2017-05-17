//
//  DetailShadowView.swift
//  Space
//
//  Created by Liliya Fedotova on 15/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

class DetailShadowView: UIView {

	func addShadow() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: -7)
		layer.shadowOpacity = 0.2
		layer.shadowRadius = 7.0
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}
	
}
