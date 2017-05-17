//
//  ViewControllerWithAnimateHeader.swift
//  Space
//
//  Created by Liliya Fedotova on 17/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

protocol ViewControllerWithAnimateHeader: class {
	weak var headerHeightConstraint: NSLayoutConstraint! {get set}
	
	var maxHeaderHeight: CGFloat {get set}
	var minHeaderHeight: CGFloat {get set}
	var previousScrollOffset: CGFloat {get set}
	var headerRation: CGFloat {get}
	
	func animateHeaderView(_ scrollView: UIScrollView)
	func updateHeader(_ currentHeaderHeight: CGFloat)
}

extension ViewControllerWithAnimateHeader {
	func animateHeaderView(_ scrollView: UIScrollView) {
		let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
		
		let absoluteTop: CGFloat = 0
		let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
		
		let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
		let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
		
		if canAnimateHeader(scrollView) {
			
			// Calculate new header height
			var newHeight = headerHeightConstraint.constant
			if isScrollingDown {
				newHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
			} else if isScrollingUp && scrollView.contentOffset.y < 0 {
				newHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
			}
			
			// Header needs to animate
			if newHeight != headerHeightConstraint.constant {
				headerHeightConstraint.constant = newHeight
				updateHeader(newHeight)
				setScrollPosition(previousScrollOffset, in: scrollView)
			}
			
			previousScrollOffset = scrollView.contentOffset.y
		}
	}
	func updateHeader(_ currentHeaderHeight: CGFloat) {
		
	}
	
	func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
		let scrollViewMinHeight = scrollView.frame.height + headerHeightConstraint.constant - maxHeaderHeight
		return scrollView.contentSize.height > scrollViewMinHeight
	}
	
	func setScrollPosition(_ position: CGFloat, in scrollView: UIScrollView) {
		scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: position)
	}
}
