//
//  HTTPClient.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import Alamofire


let HTTPClientApiHeaderKey = "X-Atlas-Api-Token"
let HTTPClientVersionHeaderKey = "X-Atlas-Version"
let HTTPClientBuildHeaderKey = "X-Atlas-Build"
let HTTPClientInstallIdHeaderKey = "X-Atlas-Install-id"


class AlamofireHTTPClient: HTTPClient {
  
  fileprivate static var AlamofireManager: SessionManager = {
    var headers = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    return SessionManager(configuration: configuration)
  }()
  
  fileprivate class func updatedManager(_ headers: [AnyHashable: Any?]? = nil) -> SessionManager {
    let defaultHeaders = AlamofireManager.session.configuration.httpAdditionalHeaders
    var newHeaders = defaultHeaders ?? [:]
    if headers != nil {
      for (key, value) in headers! {
        if let value = value {
          newHeaders[key] = value
        } else {
          newHeaders.removeValue(forKey: key)
        }
      }
    }
    let configuration = AlamofireManager.session.configuration
    configuration.httpAdditionalHeaders = newHeaders
    return SessionManager(configuration: configuration)
  }
  
  // MARK: - Protocol methods

  func postRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?) {
    performRequest(url, parameters: parameters,  method: .post, completionHandler: completionHandler)
  }
  
  func getRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?) {
    performRequest(url, parameters: parameters,  method: .get, completionHandler: completionHandler)
  }
  
  func putRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?) {
    performRequest(url, parameters: parameters,  method: .put, completionHandler: completionHandler)
  }
  
  func deleteRequest(_ url: String, parameters: [String: Any]?, completionHandler: ApiCompletionBlock?) {
    performRequest(url, parameters: parameters,  method: .delete, completionHandler: completionHandler)
  }

  // MARK: - Alamofire helper function.
  fileprivate func performRequest(_ url: String, parameters: [String: Any]? = nil, method: HTTPMethod = .get, completionHandler: ApiCompletionBlock?) {
    
    let encodeUsing: ParameterEncoding = (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default
    
		AlamofireHTTPClient.AlamofireManager.request(url, method: method, parameters: parameters, encoding: encodeUsing).responseJSON { response in
      if response.result.isSuccess {
        if let handler = completionHandler {
          handler(response.response, response.result.value as? [AnyHashable : Any], nil)
        }
      } else {
        if let handler = completionHandler {
          let json = response.result.value
          let httpCode = response.response?.statusCode ?? 400
          let userInfo: [AnyHashable: Any]? = json as? [AnyHashable: Any]
          let customErr = NetworkError(userInfo: userInfo, nCode: httpCode)
          handler(nil, nil, customErr)
        }
      }
    }
  }
}
