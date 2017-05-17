//
//  UIView+HideShowAnimation.swift
//  Space
//
//  Created by Liliya Fedotova on 15/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

extension UIView {
	
	//to hide/show view with animation
	func visible(isHidden hidden: Bool, withAnimation animation: Bool) {
    if isHidden == hidden {
      return
    }
		self.layer.removeAllAnimations()
		alpha = (hidden) ? 1 : 0
		if animation {
			UIView.transition(with: self,
			                  duration:0.3,
			                  options:.transitionCrossDissolve,
			                  animations:
				{ [weak self]() -> Void in
					self?.alpha = (hidden) ? 0 : 1
				},completion: { [weak self] (complete) in
					if complete {
						self?.isHidden = hidden
					}
			})
		} else {
			alpha = (hidden) ? 0 : 1
			isHidden = hidden
		}
	}
}
