//
//  ApiWrapper.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation

typealias ApiResultCompletionBlock = (_ response:  [AnyHashable: Any]?, _ error: AppError?) -> Void


protocol ApiWrapperProtocol: class {
	var httpClient: HTTPClient {get}
	func apiHandler(_ handler: ApiResultCompletionBlock?) -> ApiCompletionBlock
	func parseResponse(_ response: HTTPURLResponse?, result: [AnyHashable: Any]?, error: AppError?) -> ( [AnyHashable: Any]? , AppError?)
}

extension ApiWrapperProtocol {
	// MARK: Common Handler
	
	func apiHandler(_ handler: ApiResultCompletionBlock?) -> ApiCompletionBlock {
		return { [handler, weak self] (response, result, error) in
			if self == nil { return }
			let (parsResponse, parseError) = self!.parseResponse(response, result: result, error: error)
			//TODO: For dev only
			
			if AppSetup.sharedState.isDev && parseError != nil && parseError?.description != nil && parseError?.description != "" {
				//UIViewController.topMostController()?.showAlertErrorFromApi(parseError?.description ?? "")
			}
			handler?(parsResponse, parseError)
		}
	}
	
	func parseResponse(_ response: HTTPURLResponse?, result: [AnyHashable: Any]?, error: AppError?) -> ( [AnyHashable: Any]? , AppError?) {
		if (error != nil) { return (nil, error: error) }
		else {
			let httpCode = response?.statusCode ?? 400
			let json = result
			
			switch httpCode {
			case 200...299, 404:
				//self.log.verbose("\(httpCode): \(urlStr) :: \(json)")
				
				// return payload if can parse ["data"] of response
				if let json = json as? [String : AnyObject], let data = json["collection"] as? [String : Any] {
					//Insert statusCode
					return (data, nil)
				}
				
				// otherwise return full json
				return (json, nil)
				
			case 401:
				return (nil, NetworkError.UnauthorizedUser)
				
			default:
				return (nil, NoAppError())
			}
		}
	}
}
