//
//  PostApiWrapper.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

protocol PostApiWrapperProtocol: ApiWrapperProtocol {
	func posts(_ page: Int, completionHandler: ApiResultCompletionBlock?)
}

class PostApiWrapper: PostApiWrapperProtocol {
	
	internal let httpClient: HTTPClient = AlamofireHTTPClient()
	
	func posts(_ page: Int = 0, completionHandler: ApiResultCompletionBlock?) {
		guard let url = AppUrl.Api.feed.url?.absoluteString else {
			return
		}
		
		var ps: [String : Any] = [:]
		ps["page"] = page
		ps["media_type"] = "image"
		ps["q"] = "star"
		//ps["keywords"] = "born"
		
		httpClient.getRequest(url, parameters: ps, completionHandler:apiHandler(completionHandler))
	}
}
