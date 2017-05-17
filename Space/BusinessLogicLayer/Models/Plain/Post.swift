//
//  Post.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation


class Post: NSObject {
	//MARK: - Properties
	
	var postId: String?
	var title: String?
	var text: String?
	var images: ImagePack?
	
	//MARK: - Initializer
	init(postId: String? = nil, title: String? = nil, text: String? = nil, images: ImagePack? = nil) {
		self.postId = postId
		self.title = title
		self.text = text
		self.images = images
		
		super.init()
	}
}

//MARK: - PropertyKey
extension Post {
	struct PropertyKey {
		static let postId = "postId"
		static let title = "title"
		static let text = "text"
		static let thumbnailUrl = "thumbnailUrl"
	}
}

extension Post {
	override var hashValue: Int {
		let hash: Int = (self.postId?.hashValue ?? 0)
		return hash
	}
}

func ==(lhs: Post, rhs: Post) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

func ==(lhs: [Post], rhs: [Post]) -> Bool
{
	guard lhs.count == rhs.count else { return false }
	var i1 = lhs.makeIterator()
	var i2 = rhs.makeIterator()
	var isEqual = true
	while let e1 = i1.next(), let e2 = i2.next(), isEqual
	{
		isEqual = e1 == e2
	}
	return isEqual
}

