//
//  UIWindow+AppScrollStopper.swift
//  Space
//
//  Created by Liliya Fedotova on 15/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit

//https://medium.com/ios-os-x-development/improveing-on-ios-multitasking-bb6e4e1d9abd#.pt9zt3lq1

private var windowsToStopScrolling: NSMutableSet? = nil

extension UIWindow {
  
  static private func getWindowsToStopScrolling() -> NSMutableSet {
    if windowsToStopScrolling == nil {
      windowsToStopScrolling = NSMutableSet()
      
      
      let stopScrollingBlock: (Notification) -> Void = {_ in
        for window in windowsToStopScrolling! {
          (window as? UIWindow)?.recursiveStopScrolling()
        }
      }
      NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: stopScrollingBlock)
      
    }
    return windowsToStopScrolling!
  }
  
  /// Call this early on in your app's lifecycle to avoid
  /// scroll-related flashing when your app resumes from the background
  func installAppScrollStopperWhenEnterBackground() {
    type(of: self).getWindowsToStopScrolling().add(self)
  }
  
}

extension UIView {
  func recursiveStopScrolling() {
    if let scrollView = self as? UIScrollView {
      // Stop the scrolling (http://stackoverflow.com/a/3421387/3943258)
      scrollView.setContentOffset(scrollView.contentOffset, animated: false)
      
      // Stop the scroll indicators from being captured
      if scrollView.showsHorizontalScrollIndicator {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
      }
      if scrollView.showsVerticalScrollIndicator {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
      }
    }
    
    for subview in self.subviews {
      subview.recursiveStopScrolling()
    }
  }
}
