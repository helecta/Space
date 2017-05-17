//
//  DetailApiWrapper.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

protocol DetailApiWrapperProtocol: ApiWrapperProtocol {
	func detail(_ id: String, completionHandler: ApiResultCompletionBlock?)
}

class DetailApiWrapper: DetailApiWrapperProtocol {
	
	internal let httpClient: HTTPClient = AlamofireHTTPClient()
	
	func detail(_ id: String, completionHandler: ApiResultCompletionBlock?) {
		guard let url = AppUrl.Api.detail(id: id).url?.absoluteString else {
			return
		}
		
		httpClient.getRequest(url, parameters: [:], completionHandler:apiHandler(completionHandler))
	}
}
