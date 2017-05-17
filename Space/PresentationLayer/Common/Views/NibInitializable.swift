//
//  NibInitializable.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

protocol NibInitializable : class {
	static var nibName: String { get }
	var contentView : UIView? {set get}
	func loadViewFromNib() -> UIView?
	func xibSetup()
}

extension NibInitializable {
	func loadViewFromNib() -> UIView? {
		// grabs the appropriate bundle
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: Self.nibName, bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
		return view
	}
}
