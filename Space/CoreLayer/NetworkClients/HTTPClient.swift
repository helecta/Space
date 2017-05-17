//
//  HTTPClientProtocol.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

typealias ApiCompletionBlock = (_ response: HTTPURLResponse?, _ result: [AnyHashable: Any]?, _ error: AppError?) -> Void

protocol HTTPClient {
	func postRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?)
	func getRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?)
	func putRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?)
	func deleteRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?)
}
