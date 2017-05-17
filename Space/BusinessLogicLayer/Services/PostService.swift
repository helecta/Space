//
//  PostService.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol PostServiceProtocol {
	func updatePosts(page: Int, completion: (([Post]?, AppError?) -> ())?)
	//init(apiWrapper: PostApiWrapperProtocol?)
}

class PostService: PostServiceProtocol {
	fileprivate let _apiWrapper: PostApiWrapperProtocol
	
	init(apiWrapper: PostApiWrapperProtocol? = nil) {
		if let apiWrapper = apiWrapper {
			self._apiWrapper = apiWrapper
		} else {
			self._apiWrapper = PostApiWrapper()
		}
	}
	
	func updatePosts(page: Int, completion: (([Post]?, AppError?) -> ())?) {
		_apiWrapper.posts(page, completionHandler: { (result, error) -> Void in
			var posts: [Post]?
			defer {
				completion?(posts, error)
			}
			
			if nil == error {
				if let data = result as? [String : Any],
					let jsonArray = data["items"] as? [[String : Any]],
					let resultArray = Mapper<PostMappable>().mapArray(JSONArray: jsonArray) {
					posts = resultArray.filter({ (post) -> Bool in
						return post.postId != nil
					})
				}
			}
		})
	}
}
