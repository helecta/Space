//
//  FeedViewModel.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

enum FeedTableCellIdentifier {
	static let feedTableCell = "feedTableCell"
}

struct FeedDataConditions: OptionSet {
	let rawValue: UInt8
	
	init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
	
	init(_ rawValue: UInt8) {
		self.init(rawValue: rawValue)
	}
	
	static var noData = FeedDataConditions(rawValue: 1 << 1)
	static var errorHappend = FeedDataConditions(rawValue: 1 << 2)
	static var loading = FeedDataConditions(rawValue: 1 << 3)
	static var pageLoaded = FeedDataConditions(rawValue: 1 << 4)
}

class FeedViewModel: NSObject {
	
	var dataState = MutableProperty<FeedDataConditions>(FeedDataConditions())
	
	var emptyLabelText: String {
		get {
			if let errorText = _errorText.value {
				return errorText
			}
			return "EmptyLabelText".localized()
		}
	}
	
	fileprivate var _errorText = MutableProperty<String?>(nil)
	fileprivate let _postsService: PostServiceProtocol = PostService()
	fileprivate let _reachabilityService: ReachabilityServiceProtocol = ReachabilityService()
	fileprivate var _sectionsArray: [BaseTableSection] = []
	fileprivate var _page: Int = 1
  fileprivate var _isTableAnimated: Bool = false
  fileprivate var _canLoadMore: Bool = false
  
	override init() {
		super.init()
		
		_errorText.producer.startWithValues { [weak self](errorText) in
			if errorText != nil {
				self?.dataState.value.insert(.errorHappend)
			} else {
				self?.dataState.value.remove(.errorHappend)
			}
		}
		
		_reachabilityService.isNetworkConnectionReachable.producer.skipRepeats().filter({ [weak self] isReachable -> Bool in
			if isReachable == false {
				self?._errorText.value = errorTextNoInternet
			}
			return isReachable
		}).startWithValues { [weak self] isReachable in
			self?.loadData()
		}
	}
	
  func loadData() {
    dataState.value.insert(.loading)
    _errorText.value = nil
    _postsService.updatePosts(page: _page, completion: { [weak self](posts, error) in
      if nil == error {
        if let posts = posts {
          self?.updateSectionsArray(posts)
        }
        if posts?.count == 0 && self?._page == 1 {
          self?.dataState.value.insert(.noData)
        }
        self?._canLoadMore = (posts?.count != 0)
        self?.dataState.value.remove(.loading)
        self?.dataState.value.insert(.pageLoaded)
        self?._page = (self?._page)! + 1
      } else {
        self?._errorText.value = errorTextServer
      }
      self?.dataState.value.remove(.loading)
    })
  }
  
  func refreshData() {
    _page = 1
    _sectionsArray.removeAll()
    _isTableAnimated = false
    dataState.value.remove([.pageLoaded, .noData])
    loadData()
  }
  
  func setTableWasAnimated() {
    _isTableAnimated = true
  }
  func isTableAnimated() -> Bool {
    return _isTableAnimated
  }
  func canLoadMore() -> Bool {
    return _canLoadMore
  }
	
	//MARK: - Table Config
	func cellItemAtIndexPath(_ indexPath: IndexPath) -> BaseCellItem? {
		let itemsArray = _sectionsArray[indexPath.section].cellItems
		let cellItem = itemsArray[indexPath.row]
		return cellItem
	}
	
	func numberOfSections() -> Int {
		return _sectionsArray.count
	}
	
	func numberOfItemsAtSection(_ section: Int) -> Int {
		let itemsArray = _sectionsArray[section].cellItems
		return itemsArray.count
	}
	
	func totalNumberOfItems() -> Int {
		return _sectionsArray.reduce(0) { $0 +  $1.cellItems.count}
	}
	
	func title(forSection section: Int) -> String {
		return _sectionsArray[section].title ?? ""
	}
  
  // MARK: - Private
	fileprivate func updateSectionsArray(_ posts: [Post]) {
		var section: BaseTableSection
		if let oldSection = _sectionsArray.first {
			section = oldSection
      _sectionsArray.remove(at: 0)
		} else {
			section = BaseTableSection()
		}
		
		for post in posts {
			let cellItem = FeedTableCellItem()
			cellItem.cellReuseIdentifier = FeedTableCellIdentifier.feedTableCell
			cellItem.title = post.title
			cellItem.imageUrl = post.images?.thumbnailUrl
			cellItem.relatedObject = post
			section.cellItems.append(cellItem)
		}
		
    //create first section
		if section.cellItems.count != 0 {
			_sectionsArray.append(section)
		}
	}
}
