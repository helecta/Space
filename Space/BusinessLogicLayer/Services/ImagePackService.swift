//
//  ImagePackService.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation
import ObjectMapper
import Kingfisher

protocol ImagePackServiceProtocol {
	init(apiWrapper: DetailApiWrapperProtocol?)
	func updateImagePack(id: String, completion: ((ImagePack?, AppError?) -> ())?)
	func downloadImage(fromUrl url: URL, completion: ((UIImage?, AppError?) -> ())?)
}

class ImagePackService: ImagePackServiceProtocol {
	fileprivate let _apiWrapper: DetailApiWrapperProtocol
	
	required init(apiWrapper: DetailApiWrapperProtocol? = nil) {
		if let apiWrapper = apiWrapper {
			self._apiWrapper = apiWrapper
		} else {
			self._apiWrapper = DetailApiWrapper()
		}
	}
	
	func updateImagePack(id: String, completion: ((ImagePack?, AppError?) -> ())?) {
		_apiWrapper.detail(id, completionHandler: { (result, error) -> Void in
			var imagePack: ImagePack?
			defer {
				completion?(imagePack, error)
			}
			
			if nil == error {
				if let data = result as? [String : Any],
					let resultArray = Mapper<ImagePackMappable>().map(JSONObject: data) {
						imagePack = resultArray
        }
			}
		})
	}
	
	func downloadImage(fromUrl url: URL, completion: ((UIImage?, AppError?) -> ())?) {
		ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
			(image, error, url, data) in
			let appError: AppError?
			defer {
				completion?(image, appError)
			}
			if let error = error {
				appError = AppError(error: error)
			} else {
				appError = nil
			}
		}
	}
}
