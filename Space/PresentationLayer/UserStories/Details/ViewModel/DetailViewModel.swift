//
//  DetailViewModel.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

enum SaveImageState: Int {
	case imageNotDownload
	case startDownloading
	case imageDownloaded
	case imageStartSaving
	case imageSaved
	case error
}

struct AlertItem {
	var title: String
	var text: String
	var buttonText: String
	
	static let errorSaveAlertItem = AlertItem(title: "ErrorInSaveTitle".localized(), text: "ImageWasNotSave".localized(), buttonText: "OK".localized())
	static let successSaveAlertItem = AlertItem(title: "SavedTitle".localized(), text: "ImageWasSaved".localized(), buttonText: "OK".localized())
}

class DetailViewModel: NSObject {
	
	var isDataLoaded = MutableProperty<Bool>(false)
	var imageSaveState = MutableProperty<SaveImageState>(.imageNotDownload)
	
	fileprivate let _imagePackService: ImagePackServiceProtocol = ImagePackService()
	fileprivate let _reachabilityService: ReachabilityServiceProtocol = ReachabilityService()
	
	fileprivate var post: Post
	
	var alertItem: AlertItem? {
		get {
			if imageSaveState.value == .error {
				return AlertItem.errorSaveAlertItem
			}
			if imageSaveState.value == .imageSaved {
				return AlertItem.successSaveAlertItem
			}
			return nil
		}
	}
	
	var title: String {
		return post.title ?? ""
	}
	
	var text: String {
		return post.text ?? ""
	}
	
	var imageUrl: URL? {
		return (post.images?.mediumUrl == nil) ? post.images?.thumbnailUrl : post.images?.mediumUrl
	}
	
	var downloadUrl: URL? {
		return post.images?.originUrl
	}
	
	init(post: Post) {
		self.post = post
		
		super.init()
		
		_reachabilityService.isNetworkConnectionReachable.producer.skipRepeats().filter({ isReachable -> Bool in
			return isReachable
		}).startWithValues { [weak self] isReachable in
			self?.loadData()
		}
	}
	
	func loadData() {
		isDataLoaded.value = false
		guard let postId = post.postId else {
			return
		}
		_imagePackService.updateImagePack(id: postId) { [weak self](imagePack, error) in
			if error == nil {
				self?.post.images = imagePack
				self?.isDataLoaded.value = true
			}
		}
	}
	
	func downloadImage() {
		guard let downloadUrl = downloadUrl else {
			imageSaveState.value = .error
			return
		}
		imageSaveState.value = .startDownloading
		_imagePackService.downloadImage(fromUrl: downloadUrl) { [weak self](image, error) in
			if error == nil {
				guard let image = image else {
					self?.imageSaveState.value = .error
					return
				}
				self?.imageSaveState.value = .imageDownloaded
				self?.imageSaveState.value = .imageStartSaving
				UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
			} else {
				self?.imageSaveState.value = .error
			}
		}
	}
	
	@objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
		if error != nil {
			imageSaveState.value = .error
		} else {
			imageSaveState.value = .imageSaved
		}
	}
}
