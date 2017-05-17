//
//  String+Localization.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation

extension String {
	func localized(_ comment: String = "") -> String {
		return NSLocalizedString(self, comment: comment)
	}
	
}
