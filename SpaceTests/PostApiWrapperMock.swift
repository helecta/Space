//
//  PostApiWrapperMock.swift
//  Space
//
//  Created by Liliya Fedotova on 16/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
@testable import Space

enum PostApiWrapperMockType {
	case success
	case empty
	case error
	case incorrect
}

class PostApiWrapperMock: PostApiWrapperProtocol {
	
	let successPost: Post = Post(postId: "hubble-observes-one-of-a-kind-star-nicknamed-nasty_17754652960_o",
	                             title: "Hubble Observes One-of-a-Kind Star Nicknamed ‘Nasty’",
	                             text: "Astronomers using NASA’s Hubble Space Telescope",
	                             images: ImagePack(thumbnailUrl: URL(string:"https://images-assets.nasa.gov/image/hubble-observes-one-of-a-kind-star-nicknamed-nasty_17754652960_o/hubble-observes-one-of-a-kind-star-nicknamed-nasty_17754652960_o~thumb.jpg")))
	
	fileprivate var type: PostApiWrapperMockType
	internal let httpClient: HTTPClient = AlamofireHTTPClient()
	
	init(withType type: PostApiWrapperMockType = .success) {
		self.type = type
	}
	
	
	func posts(_ page: Int = 0, completionHandler: ApiResultCompletionBlock?) {
		
		switch type {
		case .success:
			let result: [AnyHashable: Any]? = ["items": [
				["data": [
					["nasa_id": successPost.postId,
					 "title" : successPost.title,
					 "description" : successPost.text]
					],
				 "links": [
					["href": successPost.images?.thumbnailUrl?.absoluteString]
					]
				]
			]
		]
			completionHandler?(result, nil)
			break
		case .empty:
			let empty: [AnyHashable: Any]? = ["items": []]
			completionHandler?(empty, nil)
			break
		case .error:
			completionHandler?(nil, NetworkError(userInfo: nil, nCode: 404))
			break
		case .incorrect:
			let result: [AnyHashable: Any]? = ["items": [
				["dataIncorrect": [
					["nasa_id": successPost.postId!,
					 "title" : [successPost.title],
					 "description" : successPost.text!]
					],
				 "linksIncorrect": [
					[successPost.images?.thumbnailUrl?.absoluteString]
					]
				]
			]
		]
			completionHandler?(result, nil)
			break
		}
	}
}
