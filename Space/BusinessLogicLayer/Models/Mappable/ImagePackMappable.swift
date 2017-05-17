//
//  ImagePackMappable.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagePackMappable: ImagePack, Mappable {
	//MARK: - Initializer
	
	required convenience init?(map: Map) {
		self.init()
	}
	//MARK: - Mappable
	func mapping(map: Map) {
		originUrl			<- (map[PropertyKeyApi.originUrl], URLTransform())
		mediumUrl			<- (map[PropertyKeyApi.mediumUrl], URLTransform())
		smallUrl			<- (map[PropertyKeyApi.smallUrl], URLTransform())
		thumbnailUrl	<- (map[PropertyKeyApi.thumbnailUrl], URLTransform())
	}
}

//MARK: - PropertyKey
extension ImagePackMappable {
	struct PropertyKeyApi {
		static let originUrl = "items.0.href"
		static let mediumUrl = "items.1.href"
		static let smallUrl = "items.2.href"
		static let thumbnailUrl = "items.3.href"
	}
}
