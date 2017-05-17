//
//  BaseCell.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

protocol BaseCellItem {
	var cellReuseIdentifier: String {get set}
	var cellIdentifier: String? {get set}
	var relatedObject: Any? { get set }
}

class BaseCell : UITableViewCell {
	var cellItem: BaseCellItem?
}

struct BaseTableSection {
	var cellItems: [BaseCellItem] = []
	var title: String? = ""
}
