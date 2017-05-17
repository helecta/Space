//
//  EmptyView.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

@IBDesignable class EmptyView: UIView, NibInitializable {
	
	@IBInspectable
	var labelText: String? = "EmptyLabelText".localized() {
		didSet{
			if label != nil {
				UIView.transition(with: label, duration: 0.25, options: [.transitionCrossDissolve], animations: { [weak self] _ in
					self?.label.text = self?.labelText
					}, completion: nil)
			}
		}
	}
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}
	
	//MARK: - NibInitializable
	var contentView : UIView?
	static var nibName: String = "EmptyView"
	
	func xibSetup() {
		if let contentView = loadViewFromNib() {
			contentView.frame = bounds
			contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
			addSubview(contentView)
		}
	}
}
