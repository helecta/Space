//
//  ImagePack.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagePack: NSObject {
	//MARK: - Properties	
	var originUrl: URL?
	var mediumUrl: URL?
	var smallUrl: URL?
	var thumbnailUrl: URL?

	//MARK: - Initializer
	init(originUrl: URL? = nil, mediumUrl: URL? = nil, smallUrl: URL? = nil, thumbnailUrl: URL? = nil) {
		self.originUrl = originUrl
		self.mediumUrl = mediumUrl
		self.smallUrl = smallUrl
		self.thumbnailUrl = thumbnailUrl
		
		super.init()
	}
}

//MARK: - PropertyKey
extension ImagePack {
	struct PropertyKey {
		static let originUrl = "originUrl"
		static let mediumUrl = "mediumUrl"
		static let smallUrl = "smallUrl"
		static let thumbnailUrl = "thumbnailUrl"
	}
}
