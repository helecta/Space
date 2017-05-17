//
//  FeedTableCell.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableCellItem: BaseCellItem {
	var cellReuseIdentifier: String = FeedTableCellIdentifier.feedTableCell
	var cellIdentifier: String? = nil
	var relatedObject: Any?
	
	var imageUrl: URL?
	var title: String?
}

class FeedTableCell: BaseCell {
	
	@IBOutlet weak var cardWrapper: UIView!
	@IBOutlet weak var spaceImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	override var cellItem: BaseCellItem? {
		didSet {
			if let item = cellItem as? FeedTableCellItem {

				titleLabel?.text = item.title
        spaceImage.image = nil
				spaceImage.kf.setImage(with: item.imageUrl)
				
				contentView.setNeedsLayout()
				contentView.layoutIfNeeded()
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		contentView.setNeedsLayout()
		contentView.layoutIfNeeded()
		
		addShadow()
	}
	
	fileprivate func addShadow() {
		cardWrapper.layer.shadowColor = UIColor.black.cgColor
		cardWrapper.layer.shadowOffset = CGSize(width: 0, height: 7)
		cardWrapper.layer.shadowOpacity = 0.15
		cardWrapper.layer.shadowRadius = 7.0
		cardWrapper.layer.shouldRasterize = true
		cardWrapper.layer.rasterizationScale = UIScreen.main.scale
		
	}
}

