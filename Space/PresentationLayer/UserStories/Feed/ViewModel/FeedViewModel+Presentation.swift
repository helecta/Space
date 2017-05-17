//
//  FeedViewModel+Presentation.swift
//  Space
//
//  Created by Liliya Fedotova on 16/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//
import UIKit

extension FeedViewModel {
	
	var isEmptyViewHidden: Bool {
		get {
			let state = dataState.value
			if state.contains(.noData) || (state.contains(.errorHappend) && !state.contains(.pageLoaded)) {
				return false
			}
			return true
		}
	}
	var isSpinnerViewHidden: Bool {
		get {
			let state = dataState.value
			if state.contains(.loading) && (!state.contains(.pageLoaded) && !state.contains(.errorHappend) && !state.contains(.noData)) {
				return false
			}
			return true
		}
	}
	
	var isTableViewHidden: Bool {
		get {
			let state = dataState.value
			if state.contains(.pageLoaded) {
				return false
			}
			return true
		}
	}
	
	var shouldAnimateTableViewHidden: Bool {
		get {
			let state = dataState.value
      if (state.contains(.pageLoaded) && !isTableAnimated()) {
        setTableWasAnimated()
        return true
      }
      return false
		}
	}
	
	var shouldReloadTable: Bool {
		get {
			let state = dataState.value
			if state.contains(.loading) || state.contains(.errorHappend) {
				return false
			}
			if state.contains(.pageLoaded) {
				return true
			}
			return false
		}
	}
	
	func shouldLoadNext(_ indexPath: IndexPath) -> Bool {
		// _items - сколько уже подгружено
		//нужно подсчитать какое место занимает ячейка по indexPath
		let state = dataState.value
		guard canLoadMore() && state.contains(.pageLoaded) && !state.contains(.loading) else {
			return false
		}
		let cellItemsLoadedTotal = totalNumberOfItems()
		let fromBottomConstant = 30
		if cellItemsLoadedTotal <= fromBottomConstant {
			return false
		}
		
		var itemsCountFromPrevSections = 0
		let endSection = indexPath.section - 1
		if endSection >= 0 {
			for i in 0...endSection  {
				itemsCountFromPrevSections = itemsCountFromPrevSections + numberOfItemsAtSection(i)
			}
		}
		let cellTotalIndex = (indexPath.row + 1) + itemsCountFromPrevSections
		if cellTotalIndex > cellItemsLoadedTotal - fromBottomConstant {
			return true
		}
		return false
	}
}
