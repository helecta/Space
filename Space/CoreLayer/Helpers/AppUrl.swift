//
//  AppUrl.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation

/**
	API Reference: https://images.nasa.gov/docs/images.nasa.gov_api_docs.pdf
*/

struct SPCDomain {
	let prodDomain: String
	let devDomain: String?
	
	var urlDomain: String {
		if let devDomain = devDomain {
			return AppSetup.sharedState.isDev ? devDomain : prodDomain
		}
		return prodDomain
	}
}

struct SPCUrl {
	var domain: SPCDomain
	let path: String
	let prefix: String?
	
	var string: String {
		if let prefix = prefix {
			return "\(domain.urlDomain)/\(prefix)/\(path)"
		}
		return "\(domain.urlDomain)/\(path)"
	}
	
	var url: URL? {
		return URL(string: self.string)
	}
	
	init(domain: SPCDomain = AppDomain.api, path: String, prefix: String? = nil) {
		self.domain = domain
		self.path = path
		self.prefix = prefix
	}
}

enum AppDomain {
	static let api				= SPCDomain(prodDomain: "https://images-api.nasa.gov", devDomain: "https://images-api.nasa.gov")
	static let deepLink		= SPCDomain(prodDomain: "space:/", devDomain: nil)
	static let appStore   = SPCDomain(prodDomain: "itms-apps://itunes.apple.com", devDomain: nil)
}

/**

This enum contains all apps urls
To get URL type need to call url property

*/

enum AppUrl {
	static let appStore		= SPCUrl(domain: AppDomain.appStore, path: "WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1102821887&action=write-review")
	
	enum Api {
		case feed
		case detail(id: String)
		
		var url: URL? {
			switch self {
			case .feed:
				return SPCUrl(domain: AppDomain.api, path: "search").url
			case .detail(let id):
				return SPCUrl(domain: AppDomain.api, path: "asset/\(id)").url
			}
			return nil
		}
		
	}

	
}
