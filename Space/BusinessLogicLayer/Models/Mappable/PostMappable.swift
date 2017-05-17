//
//  PostMappable.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
import ObjectMapper

class PostMappable: Post, Mappable {	
	//MARK: - Initializer

	required convenience init?(map: Map) {
		self.init()
	}
	
	//MARK: - Mappable
	func mapping(map: Map) {
		postId						<- map[PropertyKeyApi.postId]
		title							<- map[PropertyKeyApi.title]
		text							<- map[PropertyKeyApi.text]
		
		
		if images == nil {
			images = ImagePack()
		}
		guard let images = images else {
			return
		}
		images.thumbnailUrl			<- (map[PropertyKeyApi.thumbnailUrl], URLTransform())
	}
}

//MARK: - PropertyKey
extension PostMappable {
	struct PropertyKeyApi {
			static let postId = "data.0.nasa_id"
			static let title = "data.0.title"
			static let text = "data.0.description"
			static let thumbnailUrl = "links.0.href"
	}
}
