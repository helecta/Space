//
//  AppError.swift
//  Hello
//
//  Created by Liliya on 04/05/16.
//  Copyright © 2016 Peekaboo. All rights reserved.
//

import Foundation

class AppError: Error, Hashable {
	var description: String
	var code: Int
	var domain: String = "BaseErrorDomain"
	
	static let Unknown = AppError(description: "UnknownError".localized(), code: 0)
	
	init() {
		self.description = ""
		self.code = -1
	}
	
	init(description: String, code: Int) {
		self.description = description
		self.code = code
	}
	
	init(error: NSError) {
		self.description = error.localizedDescription
		self.code = error.code
	}
	
	func update(_ error: AppError) {
		description = error.description
		code = error.code
	}
	
}

extension AppError {
	var hashValue: Int {
		return "\(domain)\(code)".hashValue
	}
}

class NoAppError : AppError {
	
	override init() {
		super.init(description: "", code: -1)
	}
	
}

func ==(lhs: AppError, rhs: AppError) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

