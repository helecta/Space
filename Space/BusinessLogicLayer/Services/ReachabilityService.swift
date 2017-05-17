//
//  ReachabilityService.swift
//  Space
//
//  Created by Liliya Fedotova on 13/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import ReachabilitySwift

protocol ReachabilityServiceProtocol {
	var isNetworkConnectionReachable: MutableProperty<Bool> {get set}
}

class ReachabilityService: ReachabilityServiceProtocol {
	
	var isNetworkConnectionReachable = MutableProperty<Bool>(true)
	
	fileprivate var reachability : Reachability?
	
	init() {
		reachability = Reachability()
		
		addHandlers()
		startObserve()
	}
	
	fileprivate func addHandlers() {
		reachability?.whenReachable = {[weak self] reachability in
			self?.isNetworkConnectionReachable.value = true
		}
		
		reachability?.whenUnreachable = {[weak self] reachability in
			self?.isNetworkConnectionReachable.value = false
		}
	}
	
	fileprivate func startObserve() {
		do {
			try reachability?.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
	
	deinit {
		reachability?.stopNotifier()
	}
}
